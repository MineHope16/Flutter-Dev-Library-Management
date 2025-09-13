import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:openlibrary_book_explorer/utils/Routes.dart';
import 'package:openlibrary_book_explorer/Presentation/CommonWidgets/AuthenticationTextField.dart';
import 'package:openlibrary_book_explorer/Presentation/Elements/CustomBottom.dart';
import 'package:openlibrary_book_explorer/Presentation/Elements/CustomText.dart';
import 'package:provider/provider.dart';
import '../../Providers/AuthenticationProvider.dart';
import '../Elements/CustomContainer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool acceptedTerms = false;

  bool validateForm() {
    if (nameController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        numberController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "All fields are required.";
      });
      return false;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      setState(() {
        errorMessage = "Please enter a valid email address.";
      });
      return false;
    }
    if (passwordController.text.trim().length < 6) {
      setState(() {
        errorMessage = "Password must be at least 6 characters.";
      });
      return false;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      setState(() {
        errorMessage = "Passwords do not match.";
      });
      return false;
    }
    if (!acceptedTerms) {
      setState(() {
        errorMessage = "You must accept the terms and conditions.";
      });
      return false;
    }
    int? age = int.tryParse(ageController.text.trim());
    if (age == null || age < 1) {
      setState(() {
        errorMessage = "Please enter a valid age.";
      });
      return false;
    }
    setState(() {
      errorMessage = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: MyContainer(
        height: double.infinity,
        decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              /// Title Text
              MyText(
                text: "Join the Library of Millions",
                size: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
              const SizedBox(height: 10),

              /// Subtitle Text
              MyText(
                text:
                    "Save favorites, track authors, and discover books tailored to you.",
                size: 17,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: themeProvider.secondaryTextColor,
              ),
              const SizedBox(height: 30),

              /// Name TextField
              AuthenticationTextField(
                controller: nameController,
                keyboard: TextInputType.name,
                hintText: "Name",
                suffixIcon: Icons.person_outline,
                isPasswordField: false,
              ),
              const SizedBox(height: 10),

              /// Age TextField
              AuthenticationTextField(
                controller: ageController,
                keyboard: TextInputType.number,
                hintText: "Age",
                suffixIcon: Icons.cake_outlined,
                isPasswordField: false,
              ),
              const SizedBox(height: 10),

              /// Phone Number TextField
              AuthenticationTextField(
                controller: numberController,
                keyboard: TextInputType.phone,
                hintText: "Phone",
                suffixIcon: Icons.phone_outlined,
                isPasswordField: false,
              ),
              const SizedBox(height: 10),

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

              /// Confirm Password TextField
              AuthenticationTextField(
                controller: confirmPasswordController,
                keyboard: TextInputType.visiblePassword,
                hintText: "Confirm Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 10),

              /// Terms and Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: acceptedTerms,
                    onChanged: (value) {
                      setState(() {
                        acceptedTerms = value ?? false;
                        if (acceptedTerms &&
                            errorMessage ==
                                "You must accept the terms and conditions.") {
                          errorMessage = null;
                        }
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          acceptedTerms = !acceptedTerms;
                          if (acceptedTerms &&
                              errorMessage ==
                                  "You must accept the terms and conditions.") {
                            errorMessage = null;
                          }
                        });
                      },
                      child: MyText(
                        text: "I agree to the Terms and Conditions",
                        size: 14,
                        color: themeProvider.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Error Message
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              /// Below Button
              Consumer<AuthenticationProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          btnLabel: "Sign Up",
                          paddingLeft: 70,
                          paddingRight: 70,
                          onPressed: () {
                            if (validateForm()) {
                              provider.signUp(
                                nameController.text.trim(),
                                int.tryParse(ageController.text.trim()) ?? 0,
                                numberController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                context,
                              );
                            }
                          },
                        );
                },
              ),

              const SizedBox(height: 20),

              /// Navigate Login Screen Text
              Align(
                alignment: Alignment.bottomRight,
                child: MyText(
                  text: "Already have an account? LogIn",
                  size: 12,
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.right,
                  decoration: TextDecoration.underline,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
