import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

/// Maneja todas las operaciones de Firestore para los hábitos.
/// Los hábitos se guardan bajo la colección: users/{uid}/habits
class HabitRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Referencia a la colección de hábitos del usuario autenticado.
  CollectionReference<Map<String, dynamic>> _habitsRef(String uid) {
    return _db.collection('users').doc(uid).collection('habits');
  }

  /// Retorna todos los hábitos del usuario ordenados por fecha de creación.
  Future<List<Habit>> getHabits(String uid) async {
    final snapshot = await _habitsRef(uid)
        .orderBy('createdAt', descending: false)
        .get();
    return snapshot.docs
        .map((doc) => Habit.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Crea un nuevo hábito en Firestore.
  /// Retorna el hábito con el ID asignado por Firestore.
  Future<Habit> addHabit(String uid, Habit habit) async {
    final doc = await _habitsRef(uid).add(habit.toMap());
    return habit.copyWith();
  }

  /// Actualiza el nombre, ícono o color de un hábito existente.
  Future<void> updateHabit(String uid, Habit habit) async {
    await _habitsRef(uid).doc(habit.id).update({
      'name': habit.name,
      'icon': habit.icon,
      'color': habit.color,
    });
  }

  /// Elimina un hábito y todo su historial de Firestore.
  Future<void> deleteHabit(String uid, String habitId) async {
    await _habitsRef(uid).doc(habitId).delete();
  }

  /// Marca o desmarca un hábito como completado en una fecha específica.
  Future<void> toggleCompletion(
      String uid, String habitId, String date) async {
    final doc = await _habitsRef(uid).doc(habitId).get();
    final dates = List<String>.from(doc.data()?['completedDates'] ?? []);

    if (dates.contains(date)) {
      dates.remove(date);
    } else {
      dates.add(date);
    }

    await _habitsRef(uid).doc(habitId).update({'completedDates': dates});
  }
}