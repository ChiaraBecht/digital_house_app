import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomScreen extends StatelessWidget {
  final Room room;

  const RoomScreen({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${room.icon} ${room.name}'),
      ),
      body: Center(
  child: Text(
    room.name,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}