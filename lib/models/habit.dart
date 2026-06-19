/// Cada hábito pertenece a un usuario identificado por su UID de Firebase.
class Habit {
  final String id;
  final String name;
  final String icon;
  final String color;
  final DateTime createdAt;
  /// Formato: 'yyyy-MM-dd'
  final List<String> completedDates;

  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.createdAt,
    required this.completedDates,
  });

  /// Crea un Habit desde un documento de Firestore.
  factory Habit.fromMap(String id, Map<String, dynamic> map) {
    return Habit(
      id: id,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedDates: List<String>.from(map['completedDates'] ?? []),
    );
  }

  /// Convierte el Habit a un Map para guardar en Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates,
    };
  }

  /// Retorna una copia del hábito con los campos modificados.
  Habit copyWith({
    String? name,
    String? icon,
    String? color,
    List<String>? completedDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  /// Retorna la racha actual del hábito.
  /// Cuenta los días consecutivos completados hacia atrás desde ayer o hoy.
  int get currentStreak {
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      if (completedDates.contains(key)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Retorna los días completados en el mes actual.
  int get completedThisMonth {
    final now = DateTime.now();
    return completedDates.where((date) {
      final parts = date.split('-');
      return int.parse(parts[0]) == now.year &&
          int.parse(parts[1]) == now.month;
    }).length;
  }
}