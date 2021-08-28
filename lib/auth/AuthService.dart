import 'package:dynamic_cast/i18n/translation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  bool get isSignedIn => _userCredential != null;

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return str.passwordTooWeak;

        case 'email-already-in-use':
          return str.emailAlreadyInUse;

        default:
          return str.somethingWentWrong;
      }
    }
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      _userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          return str.userNotFound;

        default:
          return str.somethingWentWrong;
      }
    }
  }
}

final auth = AuthService();
