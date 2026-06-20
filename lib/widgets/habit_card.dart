import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../config/app_colors.dart';
import '../config/app_icons.dart';
import '../screens/habit_detail/habit_detail_screen.dart';

/// Tarjeta que representa un hábito en la lista principal.
/// Permite marcar/desmarcar como completado y navegar al detalle.
class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final String todayKey;

  const HabitCard({
    super.key,
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
            final uid = context.read<AuthProvider>().currentUser!.uid;
            if (isCompleted) {
              _confirmUnmark(context, uid);
            } else {
              context
                  .read<HabitProvider>()
                  .toggleCompletion(uid, habit.id, todayKey);
            }
          },
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HabitDetailScreen(habit: habit),
          ),
        ),
      ),
    );
  }

  /// Muestra diálogo de confirmación antes de desmarcar un hábito completado.
  void _confirmUnmark(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desmarcar hábito'),
        content:
            Text('¿Seguro que quieres desmarcar "${habit.name}" de hoy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<HabitProvider>()
                  .toggleCompletion(uid, habit.id, todayKey);
            },
            child: const Text('Desmarcar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}