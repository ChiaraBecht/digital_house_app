import 'package:digital_house/models/room.dart';
import 'package:flutter/material.dart';
import '../repositories/room_repository.dart';
import 'rooms_screen.dart';
import '../data/room_templates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final roomRepository = RoomRepository();
  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('🏠 Add Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose room type'),
              ...roomTemplates.map(
                (template) => ListTile(
                  leading: Text(
                    template.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(template.name),
                  onTap: () {
                    setState(() {
                      roomRepository.addRoom(
                        Room(
                          id: template.id,
                          name: template.name,
                          icon: template.icon,
                        ),
                      );
                    });

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
          ...roomRepository.rooms.map(
            (room) => Card(
              child: ListTile(
                leading: Text(
                  room.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(room.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(room: room),
                    ),
                  );
                },
              ))
          ),
              ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showAddRoomDialog();
                },
                child: const Icon(Icons.add),
                ),
          );
  }
}