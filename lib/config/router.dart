import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/habit_detail/habit_detail_screen.dart';
import '../screens/habit_form/habit_form_screen.dart';
import '../screens/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
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