import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthResult {
  final String? uid;
  final String? error;

  AuthResult.success(this.uid) : error = null;
  AuthResult.failure(this.error) : uid = null;

  bool get isSuccess => uid != null;
}

class AuthUser {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print("Error en Google: $e");
    }
    return null;
  }

  Future<UserCredential?> singEmailPass(String email, String passw) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: passw,
      );
    } catch (e) {
      log("Fallo autenticar correo y clave: $e");
    }
    return null;
  }

  Future<AuthResult> createUserEmailPass(String email, String passw) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passw,
      );
      return AuthResult.success(credencial.user?.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_translateAuthError(e));
    } catch (e) {
      return AuthResult.failure('Error inesperado: $e');
    }
  }

  String _translateAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'El correo ya está registrado, prueba con otro';
      case 'invalid-email':
        return 'Formato de correo inválido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }

  Future<void> sendPassReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error al recuperar clave: " + e.toString());
    }
  }
}
