import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Send email verification
    User? user = userCredential.user;
    if (user != null) {
      // Update user display name first to make emails look more professional
      await user.updateDisplayName('OpenLibrary Explorer User');

      // Send verification email (using default Firebase settings)
      await user.sendEmailVerification();
    }

    return userCredential.user;
  }

  ///Login
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  ///Reset Password
  Future resetPassword(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  /// Logout
  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
