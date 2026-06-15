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
}