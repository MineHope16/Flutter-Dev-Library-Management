import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/ChangeModeProvider.dart';
import '../CommonWidgets/AuthenticationTextField.dart';
import '../Elements/CustomBottom.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              text: "Lost the Key to Your Library?",
              size: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
            const SizedBox(height: 10),

            /// Subtitle Text
            MyText(
              text:
              "Don’t worry, reset your password and unlock your bookshelf again.",
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
            const SizedBox(height: 20),

            /// Below Button
            MyButton(
              btnLabel: "Check Email",
              paddingLeft: 70,
              paddingRight: 70,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
