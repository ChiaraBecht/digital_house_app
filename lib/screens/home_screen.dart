import 'package:flutter/material.dart';
import '../data/rooms.dart';
import 'kitchen_screen.dart';
import '../navigation/room_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Digital House'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
            (room) => Card(
              child: ListTile(
                leading: Text(
                  room.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(room.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final builder = roomRoutes[room.id];

                  if (builder != null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: builder,
                      ),
                    );
                  }
                },
              ))
          ),
              ],
              ),
          );
  }
}