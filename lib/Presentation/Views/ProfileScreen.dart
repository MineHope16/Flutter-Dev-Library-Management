import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Providers/ChangeModeProvider.dart';
import '../../Providers/AuthenticationProvider.dart';
import '../../utils/Routes.dart';
import '../../utils/AppStrings.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';
import '../Elements/CustomBottom.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: AppStrings.profileScreenTitle,
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: themeProvider.buttonBackgroundColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        ),
      ),
      body: SafeArea(
        child: MyContainer(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: currentUser != null
              ? Column(
                  children: [
                    // Profile Header
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.purple.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Profile Avatar
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            // User Name
                            MyText(
                              text:
                                  currentUser.displayName ??
                                  AppStrings.openlibraryUser,
                              color: Colors.white,
                              size: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 8),
                            // User Email
                            MyText(
                              text: currentUser.email ?? "",
                              color: Colors.white.withOpacity(0.9),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Account Information
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: AppStrings.accountInformation,
                              size: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.primaryTextColor,
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: AppStrings.email,
                              value:
                                  currentUser.email ?? AppStrings.notProvided,
                              themeProvider: themeProvider,
                            ),
                            _buildInfoRow(
                              icon: Icons.verified_user_outlined,
                              label: AppStrings.emailVerified,
                              value: currentUser.emailVerified
                                  ? AppStrings.yes
                                  : AppStrings.notVerified,
                              themeProvider: themeProvider,
                              valueColor: currentUser.emailVerified
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            _buildInfoRow(
                              icon: Icons.date_range_outlined,
                              label: AppStrings.accountCreated,
                              value:
                                  currentUser.metadata.creationTime
                                      ?.toString()
                                      .split(' ')[0] ??
                                  AppStrings.unknown,
                              themeProvider: themeProvider,
                            ),
                            _buildInfoRow(
                              icon: Icons.access_time_outlined,
                              label: AppStrings.lastSignIn,
                              value:
                                  currentUser.metadata.lastSignInTime
                                      ?.toString()
                                      .split(' ')[0] ??
                                  AppStrings.unknown,
                              themeProvider: themeProvider,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Spacer(),

                    // Logout Button
                    MyButton(
                      btnLabel: AppStrings.logout,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    AppStrings.logout,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                "Are you sure you want to logout from your account?",
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await authProvider.logout();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Logout"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      color: Colors.red,
                    ),

                    SizedBox(height: 20),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off_outlined,
                        size: 80,
                        color: themeProvider.primaryTextColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      MyText(
                        text: "No user logged in",
                        size: 18,
                        color: themeProvider.primaryTextColor.withOpacity(0.7),
                      ),
                      SizedBox(height: 24),
                      MyButton(
                        btnLabel: "Go to Login",
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeProvider themeProvider,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: themeProvider.primaryTextColor.withOpacity(0.7),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: label,
                  size: 14,
                  color: themeProvider.primaryTextColor.withOpacity(0.7),
                ),
                MyText(
                  text: value,
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? themeProvider.primaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
