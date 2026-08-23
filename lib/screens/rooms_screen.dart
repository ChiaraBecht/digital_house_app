import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/storage_unit.dart';
import '../models/storage_unit_template.dart';

import '../repositories/storage_unit_repository.dart';
import '../repositories/compartment_repository.dart';

import '../data/storage_unit_templates.dart';

import './storage_unit_screen.dart';


class RoomScreen extends StatefulWidget {
  final Room room;
  final StorageUnitRepository storageUnitRepository;
  final CompartmentRepository compartmentRepository;

  const RoomScreen({
    super.key,
    required this.room,
    required this.storageUnitRepository,
    required this.compartmentRepository,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _storageUnitNameController = TextEditingController();

  void _createStorageUnitFromTemplate(StorageUnitTemplate template) async {
    final name = _storageUnitNameController.text.trim();

    if  (name.isEmpty) {
      return;
    }

    final storageUnit = StorageUnit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: template.id,
      icon: template.icon,
      roomId: widget.room.id,
    );

    await widget.storageUnitRepository.addStorageUnit(storageUnit);

    if (mounted) {
      setState(() {});
    }
  }

  void _showStorageUnitNameDialog(StorageUnitTemplate template) {
    _storageUnitNameController.text = template.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${template.icon} Name your storage unit'),
          content: TextField(
            controller: _storageUnitNameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Storage unit name',
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
              onPressed: () {
                _createStorageUnitFromTemplate(template);
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStorageUnitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Storage Unit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...storageUnitTemplates.map(
                (template) => ListTile(
                  leading: Text(
                    template.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(template.name),
                  onTap: () {
                    Navigator.pop(context);
                    _showStorageUnitNameDialog(template);
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
    final roomStorageUnits = widget.storageUnitRepository.storageUnits
      .where((unit) => unit.roomId == widget.room.id)
      .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.room.icon} ${widget.room.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...roomStorageUnits.map(
            (roomStorageUnit) => Card(
              child: ListTile(
                leading: Text(
                  roomStorageUnit.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(roomStorageUnit.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete storage unit?'),
                              content: Text(
                                'Are you sure you want to delete "${roomStorageUnit.name}"?',
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
                          final compartmentsToDelete = widget.compartmentRepository
                              .compartments
                              .where(
                                (compartment) =>
                                    compartment.storageUnitId == roomStorageUnit.id,
                              )
                              .toList();

                          for (final compartment in compartmentsToDelete) {
                            await widget.compartmentRepository.deleteCompartment(
                              compartment.id,
                            );
                          }

                          await widget.storageUnitRepository.deleteStorageUnit(
                            roomStorageUnit.id,
                          );

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
                      builder: (context) => StorageUnitScreen(
                        storageUnit: roomStorageUnit,
                        compartmentRepository: widget.compartmentRepository,
                        ),
                      ),
                  );
                },
              ))
          ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddStorageUnitDialog();
          },
          child: const Icon(Icons.add),
          ),
    );
  }
}