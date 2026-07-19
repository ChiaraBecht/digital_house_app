import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Digital House'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome home!', 
          style: TextStyle(
            fontSize: 28),
            ), 
          SizedBox(
            height: 20,
            ),
          Text(
            'Choose a room to begin with', 
            style: TextStyle(
              fontSize: 26)
              )
              ]),
          ),
    );
  }
}