import 'package:flutter/material.dart';
import '../models/habit.dart';

/// Grilla del mes actual con los días marcados según completado.
class MonthGrid extends StatelessWidget {
  final Habit habit;
  final Color color;
  final DateTime now;

  const MonthGrid({
    super.key,
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
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold),
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
                border: isToday
                    ? Border.all(color: color, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
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
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return names[month];
  }
}