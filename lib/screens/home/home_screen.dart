import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/habit_card.dart';
import '../../widgets/empty_state.dart';
import '../habit_form/habit_form_screen.dart';

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
              ? const EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: habitProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
                    final isCompleted =
                        habit.completedDates.contains(todayKey);
                    return HabitCard(
                      habit: habit,
                      isCompleted: isCompleted,
                      todayKey: todayKey,
                    );
                  },
                ),
      floatingActionButton: habitProvider.habits.length < 5
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HabitFormScreen(),
                ),
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}