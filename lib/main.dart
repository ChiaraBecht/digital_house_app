import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DigitalHouseApp());
}

class DigitalHouseApp extends StatelessWidget {
  const DigitalHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital House',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen()
    );
  }
}