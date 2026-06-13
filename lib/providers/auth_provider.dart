import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Maneja el estado de autenticación del usuario.
/// Expone el usuario actual y los métodos de login y logout.
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Usuario actualmente autenticado. Null si no hay sesión activa.
  User? get currentUser => _auth.currentUser;

  /// True si hay un usuario autenticado.
  bool get isAuthenticated => _auth.currentUser != null;

  /// Inicia sesión con Google y Firebase Auth.
  /// Retorna true si el login fue exitoso, false si el usuario canceló.
  Future<bool> signInWithGoogle() async {
    try {
      debugPrint('>>> Iniciando Google Sign In');
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint('>>> googleUser: $googleUser');

      if (googleUser == null) {
        debugPrint('>>> Usuario canceló');
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint('>>> idToken: ${googleAuth.idToken != null}');

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      debugPrint('>>> Firebase user: ${result.user?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('>>> ERROR: $e');
      return false;
    }
  }

  /// Cierra la sesión actual en Firebase y Google.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }
}