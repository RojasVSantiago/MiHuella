import 'package:flutter/material.dart';

/// Lista de íconos predefinidos disponibles para los hábitos.
/// Cada entrada tiene un nombre descriptivo y su IconData.
class AppIcons {
  static const List<Map<String, dynamic>> habitIcons = [
    {'name': 'fitness',   'icon': Icons.fitness_center},
    {'name': 'book',      'icon': Icons.menu_book},
    {'name': 'water',     'icon': Icons.water_drop},
    {'name': 'sleep',     'icon': Icons.bedtime},
    {'name': 'food',      'icon': Icons.restaurant},
    {'name': 'meditate',  'icon': Icons.self_improvement},
    {'name': 'walk',      'icon': Icons.directions_walk},
    {'name': 'code',      'icon': Icons.code},
    {'name': 'music',     'icon': Icons.music_note},
    {'name': 'heart',     'icon': Icons.favorite},
  ];

  /// Retorna el IconData correspondiente a un nombre de ícono.
  /// Si no lo encuentra, retorna un ícono por defecto.
  static IconData fromName(String name) {
    final match = habitIcons.firstWhere(
      (e) => e['name'] == name,
      orElse: () => habitIcons.first,
    );
    return match['icon'] as IconData;
  }
}