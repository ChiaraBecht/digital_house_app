import 'package:digital_house/models/room.dart';
import 'package:digital_house/repositories/storage_unit_repository.dart';
import 'package:flutter/material.dart';
import '../repositories/room_repository.dart';
import 'rooms_screen.dart';
import '../data/room_templates.dart';
import '../models/room_template.dart';
import '../repositories/compartment_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final roomRepository = RoomRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    await roomRepository.loadRooms();
    await storageUnitRepository.loadStorageUnits();
    await compartmentRepository.loadCompartments();

    if (mounted) {
      setState(() {});
    }
  }
  final storageUnitRepository = StorageUnitRepository();
  final compartmentRepository = CompartmentRepository();
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

  void _showEditRoomDialog(Room room) {
    final controller = TextEditingController(
      text: room.name,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit room'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Room name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) {
                  return;
                }

                await roomRepository.updateRoom(
                  room.id,
                  newName,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }

                if (mounted) {
                  setState(() {});
                }
              },
              child: const Text('Save'),
            ),
          ],
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditRoomDialog(room);
                      },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete room?'),
                              content: Text(
                                'Are you sure you want to delete "${room.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          // Find all storage units beloging to this room
                          final roomStorageUnits = storageUnitRepository.storageUnits
                          .where(
                            (storageUnit) => storageUnit.roomId == room.id,
                          )
                          .toList();

                          // Delete all compartments belonging to those storage units
                          for ( final storageUnit in roomStorageUnits) {
                            final storageUnitCompartments = compartmentRepository.compartments
                            .where(
                              (compartment) =>
                              compartment.storageUnitId == storageUnit.id,
                            ).toList();

                            for ( final compartment in storageUnitCompartments) {
                              await compartmentRepository.deleteCompartment(
                                compartment.id,
                              );
                            }
                            // Delete the storage unit itself.
                            await storageUnitRepository.deleteStorageUnit(
                              storageUnit.id,
                            );
                          }
                          // finally delete the room.
                          await roomRepository.deleteRoom(room.id);

                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(
                        room: room,
                        storageUnitRepository: storageUnitRepository,
                        compartmentRepository: compartmentRepository,
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