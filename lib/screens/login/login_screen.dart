import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

/// Pantalla de inicio de sesión.
/// Permite al usuario autenticarse con su cuenta de Google.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controla si el botón de login está en estado de carga.
  bool _isLoading = false;

  /// Inicia el flujo de autenticación con Google.
  /// Redirige a Home si el login es exitoso.
  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.track_changes, size: 80),
              const SizedBox(height: 24),
              const Text(
                'MiHuella',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Registra tus hábitos diarios',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 64),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : OutlinedButton.icon(
                      onPressed: _handleSignIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Continuar con Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}