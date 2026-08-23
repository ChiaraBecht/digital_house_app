import 'package:digital_house/repositories/compartment_repository.dart';
import 'package:flutter/material.dart';
import '../models/storage_unit.dart';
import '../models/compartment.dart';

class StorageUnitScreen extends StatefulWidget {
  final StorageUnit storageUnit;
  final CompartmentRepository compartmentRepository;

  const StorageUnitScreen({
    super.key,
    required this.storageUnit,
    required this.compartmentRepository,
  });

  @override
  State<StorageUnitScreen> createState() => _StorageUnitScreenState();
}

class _StorageUnitScreenState extends State<StorageUnitScreen> {
  void _showEditCompartmentDialog(Compartment compartment) {
    final controller = TextEditingController(
      text: compartment.name,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit compartment'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Compartment name',
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

                await widget.compartmentRepository.updateCompartment(
                  compartment.id,
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
    final storageUnitCompartments =
      widget.compartmentRepository.compartments
          .where(
            (compartment) =>
                compartment.storageUnitId == widget.storageUnit.id,
          )
          .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.storageUnit.icon} ${widget.storageUnit.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.storageUnit.name,
              style: const TextStyle(fontSize: 30),
              ),
            Text('Type: ${widget.storageUnit.type}'),
            const SizedBox(height: 30),
            Text(
              "Compartments",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
              ),
            const SizedBox(height: 10),
            if (storageUnitCompartments.isEmpty)
              const Text('No compartments yet'),

            ...storageUnitCompartments.map(
              (compartment) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(compartment.name,
                  style: const TextStyle(fontWeight: FontWeight.bold,
                  ),
                  ),
                  subtitle: Text('Owner: ${compartment.owner}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditCompartmentDialog(compartment);
                        },
                      ),
                      IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete compartment?'),
                              content: Text(
                                'Are you sure you want to delete "${compartment.name}"?',
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
                          await widget.compartmentRepository.deleteCompartment(
                            compartment.id,
                          );

                          if (mounted) {
                            setState(() {});
                          }
                        }
                      }, 
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
      );
  }
}