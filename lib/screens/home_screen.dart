import 'package:flutter/material.dart';
import '../data/rooms.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Digital House'),
      ),
      body: Center(
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
              ),
          SizedBox(height: 30),
          ...rooms.map(
            (room) => Text(
              '${room.icon} ${room.name}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
              ],
              ),
          ),
    );
  }
}