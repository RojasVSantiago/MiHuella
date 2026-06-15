import 'package:flutter/material.dart';

/// Paleta de 6 colores disponibles para los hábitos.
/// Cada color tiene un nombre, valor hex y objeto Color de Flutter.
class AppColors {
  static const List<Map<String, dynamic>> habitColors = [
    {'name': 'Coral',    'hex': 'FF6B6B', 'color': Color(0xFFFF6B6B)},
    {'name': 'Turquesa', 'hex': '4ECDC4', 'color': Color(0xFF4ECDC4)},
    {'name': 'Azul',     'hex': '45B7D1', 'color': Color(0xFF45B7D1)},
    {'name': 'Verde',    'hex': '96CEB4', 'color': Color(0xFF96CEB4)},
    {'name': 'Amarillo', 'hex': 'FFEAA7', 'color': Color(0xFFFFEAA7)},
    {'name': 'Lila',     'hex': 'DDA0DD', 'color': Color(0xFFDDA0DD)},
  ];

  /// Convierte un hex string a Color de Flutter.
  static Color fromHex(String hex) {
    return Color(int.parse('FF$hex', radix: 16));
  }
}