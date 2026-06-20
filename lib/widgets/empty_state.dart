import 'package:flutter/material.dart';

/// Muestra un mensaje cuando el usuario no tiene hábitos creados.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

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