import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/habit_detail/habit_detail_screen.dart';
import '../screens/habit_form/habit_form_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Configuración principal del router de la app.
/// Define todas las rutas y protege las rutas privadas
/// redirigiendo a login si el usuario no está autenticado.
GoRouter appRouter(BuildContext context) {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = auth.isAuthenticated;
      final isPublicRoute =
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/login';

      if (!isAuthenticated && !isPublicRoute) return '/login';
      if (isAuthenticated && state.matchedLocation == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/habit-detail',
        builder: (context, state) => const HabitDetailScreen(),
      ),
      GoRoute(
        path: '/habit-form',
        builder: (context, state) => const HabitFormScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}