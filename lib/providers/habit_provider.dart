import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

/// Maneja el estado global de los hábitos del usuario.
/// Se comunica con HabitRepository para persistir en Firestore.
class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository = HabitRepository();

  /// Lista de hábitos del usuario autenticado.
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  /// True mientras se cargan los hábitos desde Firestore.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Carga todos los hábitos del usuario desde Firestore.
  Future<void> loadHabits(String uid) async {
    _isLoading = true;
    notifyListeners();
    _habits = await _repository.getHabits(uid);
    _isLoading = false;
    notifyListeners();
  }

  /// Agrega un nuevo hábito y recarga la lista.
  Future<void> addHabit(String uid, Habit habit) async {
    await _repository.addHabit(uid, habit);
    await loadHabits(uid);
  }

  /// Actualiza un hábito existente y recarga la lista.
  Future<void> updateHabit(String uid, Habit habit) async {
    await _repository.updateHabit(uid, habit);
    await loadHabits(uid);
  }

  /// Elimina un hábito y recarga la lista.
  Future<void> deleteHabit(String uid, String habitId) async {
    await _repository.deleteHabit(uid, habitId);
    await loadHabits(uid);
  }

  /// Marca o desmarca un hábito como completado hoy.
  Future<void> toggleCompletion(
      String uid, String habitId, String date) async {
    await _repository.toggleCompletion(uid, habitId, date);
    await loadHabits(uid);
  }
}