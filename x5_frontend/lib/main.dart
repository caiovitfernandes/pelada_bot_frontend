import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const X5BotApp());
}

class X5BotApp extends StatelessWidget {
  const X5BotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'X5 Bot',
      debugShowCheckedModeBanner: false,
      theme: x5Theme,
      home: LoginScreen(), // Inicia na tela de login
    );
  }
}