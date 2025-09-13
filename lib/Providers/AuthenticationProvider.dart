import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Models/RegistrationModel.dart';
import 'package:openlibrary_book_explorer/Services/AuthenticationServices.dart';
import 'package:openlibrary_book_explorer/Services/RegistrationServices.dart';
import 'package:openlibrary_book_explorer/utils/Routes.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool isLoading = false;

  Future signUp(
    String name,
    int age,
    String phoneNumber,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      // Step 1: Register with Authentication Service
      await AuthenticationServices().registerUser(
        email: email,
        password: password,
        name: name,
      );

      // Step 2: Save user data in Firestore (or DB)
      await RegistrationServices().createAccount(
        RegistrationModel(
          docId: DateTime.now().toIso8601String(),
          createdAt: DateTime.now().microsecondsSinceEpoch,
          name: name,
          age: age,
          phoneNumber: phoneNumber,
          email: email,
        ),
      );

      // Success → stop loading
      isLoading = false;
      notifyListeners();

      debugPrint("✅ SignUp Success - showing success dialog");

      // Show success dialog
      if (context.mounted) {
        // Show snackbar first for immediate feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful! Check your email."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Then show dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.mark_email_read, color: Colors.orange, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    "Account Created!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Welcome to OpenLibrary Book Explorer! We've sent a verification email to activate your account.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check your email (including spam folder)",
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Click the verification link to activate",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Continue to Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.login, size: 18),
                    ],
                  ),
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            );
          },
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("❌ SignUp Error: ${e.toString()}");

      // Show error snackbar and dialog
      if (context.mounted) {
        // Show snackbar first for immediate feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );

        // Show error dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    "Registration Failed",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "We couldn't create your account. Please check the details and try again.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Text(
                      e
                          .toString()
                          .replaceAll('Exception:', '')
                          .replaceAll(
                            '[firebase_auth/email-already-in-use]',
                            'Email already in use',
                          )
                          .replaceAll(
                            '[firebase_auth/weak-password]',
                            'Password too weak',
                          )
                          .replaceAll(
                            '[firebase_auth/invalid-email]',
                            'Invalid email format',
                          ),
                      style: TextStyle(color: Colors.red[800], fontSize: 14),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Try Again",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.refresh, size: 18),
                    ],
                  ),
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            );
          },
        );
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await AuthenticationServices().loginUser(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("❌ Login Error: ${e.toString()}");
      return false; // ❌ failure
    }
  }

  Future<bool> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await AuthenticationServices().logoutUser();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("❌ Logout Error: ${e.toString()}");
      return false;
    }
  }
}
