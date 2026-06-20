import 'package:flutter/material.dart';

/// Tarjeta que muestra la racha actual del hábito.
class StreakCard extends StatelessWidget {
  final int streak;
  final Color color;

  const StreakCard({super.key, required this.streak, required this.color});

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
                      color: color),
                ),
                const Text('racha actual',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}