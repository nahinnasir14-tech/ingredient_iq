import 'package:flutter/material.dart';
import 'screens/main_navigation_shell.dart';

void main() {
  runApp(const IngredientIQApp());
}

class IngredientIQApp extends StatelessWidget {
  const IngredientIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IngredientIQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F6E56), // Matches your UI spec color palette
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationShell(),
    );
  }
}