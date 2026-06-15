import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_icons.dart';

/// Pantalla principal que muestra la lista de hábitos del usuario.
/// Carga los hábitos desde Firestore al iniciar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Carga los hábitos del usuario al entrar a la pantalla.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().currentUser!.uid;
      context.read<HabitProvider>().loadHabits(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiHuella'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: habitProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : habitProvider.habits.isEmpty
              ? _EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: habitProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
                    final isCompleted =
                        habit.completedDates.contains(todayKey);
                    return _HabitCard(
                      habit: habit,
                      isCompleted: isCompleted,
                      todayKey: todayKey,
                    );
                  },
                ),
      floatingActionButton: habitProvider.habits.length < 5
          ? FloatingActionButton(
              onPressed: () => context.push('/habit-form'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// Muestra un mensaje cuando el usuario no tiene hábitos creados.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.track_changes,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No tienes hábitos todavía',
            style: TextStyle(
                fontSize: 18, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca + para crear tu primer hábito',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta que representa un hábito en la lista principal.
class _HabitCard extends StatelessWidget {
  final habit;
  final bool isCompleted;
  final String todayKey;

  const _HabitCard({
    required this.habit,
    required this.isCompleted,
    required this.todayKey,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.fromHex(habit.color);
    final icon = AppIcons.fromName(habit.icon);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(habit.name),
        subtitle: Text(
          isCompleted ? '✓ Completado hoy' : 'Pendiente hoy',
          style: TextStyle(
            color: isCompleted ? Colors.green : Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isCompleted
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: isCompleted ? color : Colors.grey.shade300,
          ),
          onPressed: () {
            final uid =
                context.read<AuthProvider>().currentUser!.uid;
            context
                .read<HabitProvider>()
                .toggleCompletion(uid, habit.id, todayKey);
          },
        ),
        onTap: () => context.push('/habit-detail', extra: habit),
      ),
    );
  }
}