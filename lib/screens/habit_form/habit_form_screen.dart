import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/habit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_icons.dart';

/// Pantalla para crear o editar un hábito.
/// Si recibe un Habit existente, entra en modo edición.
/// Si no recibe nada, entra en modo creación.
class HabitFormScreen extends StatefulWidget {
  final Habit? habit;
  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  /// Color seleccionado por el usuario.
  String _selectedColor = AppColors.habitColors.first['hex'];

  /// Ícono seleccionado por el usuario.
  String _selectedIcon = AppIcons.habitIcons.first['name'];

  bool _isLoading = false;

  /// Precarga los valores si está en modo edición.
  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.habit?.name ?? '');
    if (widget.habit != null) {
      _selectedColor = widget.habit!.color;
      _selectedIcon = widget.habit!.icon;
    }
  }

  /// Libera el controlador al destruir el widget.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Guarda el hábito nuevo o actualiza el existente.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final uid = context.read<AuthProvider>().currentUser!.uid;
    final habitProvider = context.read<HabitProvider>();

    if (widget.habit == null) {
      final newHabit = Habit(
        id: '',
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        createdAt: DateTime.now(),
        completedDates: [],
      );
      await habitProvider.addHabit(uid, newHabit);
    } else {
      final updated = widget.habit!.copyWith(
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );
      await habitProvider.updateHabit(uid, updated);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.pop('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar hábito' : 'Nuevo hábito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop('/home'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            /// Campo de nombre del hábito.
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del hábito',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            /// Selector de color.
            const Text('Color',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: AppColors.habitColors.map((c) {
                final isSelected = _selectedColor == c['hex'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedColor = c['hex']),
                  child: CircleAvatar(
                    backgroundColor: c['color'],
                    radius: 20,
                    child: isSelected
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            /// Selector de ícono.
            const Text('Ícono',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppIcons.habitIcons.map((i) {
                final isSelected = _selectedIcon == i['name'];
                final color =
                    AppColors.fromHex(_selectedColor);
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedIcon = i['name']),
                  child: CircleAvatar(
                    backgroundColor: isSelected
                        ? color.withOpacity(0.2)
                        : Colors.grey.shade100,
                    radius: 24,
                    child: Icon(
                      i['icon'],
                      color: isSelected ? color : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            /// Botón de guardar.
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                        isEditing ? 'Guardar cambios' : 'Crear hábito'),
                  ),
          ],
        ),
      ),
    );
  }
}