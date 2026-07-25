import 'package:flutter/material.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍳 Kitchen'),
      ),
      body: const Center(
        child: Text(
          'Kitchen',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}