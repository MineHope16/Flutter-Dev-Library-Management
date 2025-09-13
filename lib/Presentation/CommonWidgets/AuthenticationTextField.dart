// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:provider/provider.dart';
import '../Elements/CustomTextField.dart';

// ignore: must_be_immutable
class AuthenticationTextField extends StatelessWidget {
  TextEditingController controller;
  TextInputType? keyboard;
  String hintText;
  IconData? suffixIcon;
  bool isPasswordField = false;
  AuthenticationTextField({
    super.key,
    required this.controller,
    this.keyboard,
    required this.hintText,
    this.suffixIcon,
    required this.isPasswordField,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MyTextField(
      controller: controller,
      keyboardType: keyboard ?? TextInputType.text,
      hintText: hintText,
      hintColor: Colors.blue,
      hintSize: 15,
      textColor: themeProvider.primaryTextColor,
      suffixIcon: suffixIcon,
      suffixColor: themeProvider.primaryTextColor,
      isPasswordField: isPasswordField,
    );
  }
}
