import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/utils/Routes.dart';
import 'package:openlibrary_book_explorer/Providers/AuthenticationProvider.dart';
import 'package:provider/provider.dart';

import '../../Providers/ChangeModeProvider.dart';
import '../CommonWidgets/AuthenticationTextField.dart';
import '../Elements/CustomBottom.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: MyContainer(
        height: double.infinity,
        decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),

            /// Title Text
            MyText(
              text: "Enter Your Library",
              size: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
            const SizedBox(height: 10),

            /// Subtitle Text
            MyText(
              text:
                  "Access your saved favorites, explore authors, and pick up where you left off.",
              size: 17,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              color: themeProvider.secondaryTextColor,
            ),
            const SizedBox(height: 30),

            /// Email TextField
            AuthenticationTextField(
              controller: emailController,
              keyboard: TextInputType.emailAddress,
              hintText: "Email",
              suffixIcon: Icons.email_outlined,
              isPasswordField: false,
            ),
            const SizedBox(height: 10),

            /// Password TextField
            AuthenticationTextField(
              controller: passwordController,
              keyboard: TextInputType.visiblePassword,
              hintText: "Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 10),

            /// Forget Password
            Align(
              alignment: Alignment.bottomRight,
              child: MyText(
                text: "Forget Password",
                size: 13,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.right,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.forgetPassword);
                },
              ),
            ),
            const SizedBox(height: 30),

            /// Below Button
            MyButton(
              btnLabel: "LogIn",
              paddingLeft: 70,
              paddingRight: 70,
              onPressed: () async {
                final success = await authProvider.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (success) {
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
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Center(
                              child: const Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Successfully logged in to your OpenLibrary account. Ready to explore millions of books?",
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
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.library_books, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Discover your next favorite book!",
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w600,
                                      ),
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
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.home,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
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
                                  "Enter Library",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ],
                        actionsPadding: const EdgeInsets.fromLTRB(
                          24,
                          0,
                          24,
                          20,
                        ),
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login failed. Please try again"),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 15),

            /// Navigate SignUp Screen Text
            Align(
              alignment: Alignment.bottomRight,
              child: MyText(
                text: "Don't have an account? SignUp",
                size: 13,
                decoration: TextDecoration.underline,
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.right,
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
