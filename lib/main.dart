import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Providers/AuthenticationProvider.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:openlibrary_book_explorer/Providers/FavoritesProvider.dart';
import 'package:provider/provider.dart';
import 'utils/Routes.dart';
import 'utils/AppTheme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "OpenLibrary Explorer",
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
