import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rocmaps/auth_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final AuthUser _authService = AuthUser();
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<UserCredential?> loginGoogle() async {
    final result = await _authService.loginGoogle();
    _currentUser = result?.user;
    notifyListeners();
    return result;
  }

  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String passw,
  ) async {
    final result = await _authService.singEmailPass(email, passw);
    _currentUser = result?.user;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<UserCredential?> createUserEmailPass(String email, String passw) =>
      _authService.createUserEmailPass(email, passw);

  Future<void> sendPassReset(String email) => _authService.sendPassReset(email);
}
