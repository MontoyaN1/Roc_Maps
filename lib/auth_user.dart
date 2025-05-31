import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  void checkAccount(String correo) {
    try {
      _auth.fetchSignInMethodsForEmail(correo);
    } catch (e) {
      log("Fallo autenticar correo y clave: $e");
    }
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

  Future<UserCredential?> createUserEmailPass(
    String email,
    String passw,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passw,
      );
    } on FirebaseAuthException catch (e) {
      print("Eror en FireBase  ${e.code} - ${e.message}");
    } catch (e) {
      print("Fallo crear cuenta con correo y clave: " + e.toString());
    }
    return null;
  }

  Future<void> sendPassReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error al recuperar clave: " + e.toString());
    }
  }
}
