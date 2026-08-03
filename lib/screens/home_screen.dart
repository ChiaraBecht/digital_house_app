import 'package:digital_house/models/room.dart';
import 'package:digital_house/repositories/storage_unit_repository.dart';
import 'package:flutter/material.dart';
import '../repositories/room_repository.dart';
import 'rooms_screen.dart';
import '../data/room_templates.dart';
import '../models/room_template.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final roomRepository = RoomRepository();
  final storageUnitRepository = StorageUnitRepository();
  final TextEditingController _roomNameController = TextEditingController();
  void _showRoomNameDialog(RoomTemplate template) {
    _roomNameController.text = template.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${template.icon} Name your room'),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(
              labelText: 'Room name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_roomNameController.text.trim().isEmpty) {
                  return;
                }

                _createRoomFromTemplate(template);
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createRoomFromTemplate(RoomTemplate template) {
    setState(() {
    roomRepository.addRoom(
      Room(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _roomNameController.text.trim(),
        type: template.id,
        icon: template.icon,
      ),
    );
  });
  }
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
                    Navigator.pop(context);
                    _showRoomNameDialog(template);
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
                subtitle: Text(room.type),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(
                        room: room,
                        storageUnitRepository: storageUnitRepository,
                        ),
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