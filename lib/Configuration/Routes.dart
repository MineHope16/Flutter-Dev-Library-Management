import 'package:flutter/cupertino.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/AuthorsScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/CategoriesScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/ForgetPasswordScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/LogInScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/ProfileScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/SignUpScreen.dart';
import 'package:openlibrary_book_explorer/Presentation/Views/SearchScreen.dart';
import '../Presentation/Views/HomeScreen.dart';
import '../Presentation/Views/OnBoardingScreen.dart';
import '../Presentation/Views/SplashScreen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgetPassword = '/forgetPassword';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String authors = '/authors';
  static const String profile = '/profile';
  static const String search = '/search';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    onBoarding: (context) => OnBoardingScreen(),
    login: (context) => LogInScreen(),
    signUp: (context) => SignUpScreen(),
    forgetPassword: (context) => ForgetPasswordScreen(),
    home: (context) => HomeScreen(),
    categories: (context) => CategoriesScreen(),
    authors: (context) => AuthorsScreen(),
    profile: (context) => ProfileScreen(),
    search: (context) => SearchScreen(),
  };
}
