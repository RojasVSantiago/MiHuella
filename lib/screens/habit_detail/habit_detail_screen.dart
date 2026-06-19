import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_icons.dart';
import '../habit_form/habit_form_screen.dart';

/// Pantalla de detalle de un hábito.
/// Muestra la grilla del mes actual y la racha del hábito.
class HabitDetailScreen extends StatelessWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.fromHex(habit.color);
    final icon = AppIcons.fromName(habit.icon);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => HabitFormScreen(habit: habit)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          /// Ícono y nombre del hábito.
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  radius: 40,
                  child: Icon(icon, color: color, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          /// Racha actual.
          _StreakCard(streak: habit.currentStreak, color: color),
          const SizedBox(height: 24),

          /// Grilla del mes.
          _MonthGrid(habit: habit, color: color, now: now),
          const SizedBox(height: 24),

          /// Botón eliminar hábito.
          TextButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Eliminar hábito',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra diálogo de confirmación antes de eliminar el hábito.
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar hábito'),
        content: Text(
          '¿Seguro que quieres eliminar "${habit.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final uid = context.read<AuthProvider>().currentUser!.uid;
              await context.read<HabitProvider>().deleteHabit(uid, habit.id);
              if (!context.mounted) return;
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta que muestra la racha actual del hábito.
class _StreakCard extends StatelessWidget {
  final int streak;
  final Color color;
  const _StreakCard({required this.streak, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_fire_department, color: color, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak ${streak == 1 ? 'día' : 'días'}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Text(
                  'racha actual',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Grilla del mes actual con los días marcados.
class _MonthGrid extends StatelessWidget {
  final Habit habit;
  final Color color;
  final DateTime now;
  const _MonthGrid({
    required this.habit,
    required this.color,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final monthName = _monthName(now.month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$monthName ${now.year}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: daysInMonth,
          itemBuilder: (context, index) {
            final day = index + 1;
            final key =
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
            final isCompleted = habit.completedDates.contains(key);
            final isToday = day == now.day;
            final isFuture = day > now.day;

            return Container(
              decoration: BoxDecoration(
                color: isCompleted
                    ? color
                    : isFuture
                    ? Colors.grey.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
                border: isToday ? Border.all(color: color, width: 2) : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Retorna el nombre del mes en español.
  String _monthName(int month) {
    const names = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return names[month];
  }
}
