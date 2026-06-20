import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_icons.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/month_grid.dart';
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
              MaterialPageRoute(
                builder: (_) => HabitFormScreen(habit: habit),
              ),
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
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          /// Racha actual.
          StreakCard(streak: habit.currentStreak, color: color),
          const SizedBox(height: 24),

          /// Grilla del mes.
          MonthGrid(habit: habit, color: color, now: now),
          const SizedBox(height: 24),

          /// Botón eliminar hábito.
          TextButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('Eliminar hábito',
                style: TextStyle(color: Colors.red)),
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
            '¿Seguro que quieres eliminar "${habit.name}"? Esta acción no se puede deshacer.'),
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
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}