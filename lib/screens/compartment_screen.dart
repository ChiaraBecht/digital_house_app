import 'package:digital_house/repositories/item_repository.dart';
import '../models/compartment.dart';
import '../models/item.dart';
import 'package:flutter/material.dart';

class CompartmentScreen extends StatefulWidget {
  final Compartment compartment;
  final ItemRepository itemRepository;

  const CompartmentScreen({
    super.key,
    required this.compartment,
    required this.itemRepository,
  });

  @override
  State<CompartmentScreen> createState() => _CompartmentScreenState();
}

class _CompartmentScreenState extends State<CompartmentScreen> {
  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();
    DateTime? expirationDate;
    DateTime? openedOnDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add item'),
              content: SingleChildScrollView(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                  ),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Expiration date'),
                    subtitle: Text(
                      expirationDate == null
                          ? 'Not set'
                          : '${expirationDate!.day}.${expirationDate!.month}.${expirationDate!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: expirationDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        setDialogState(() {
                          expirationDate = pickedDate;
                        });
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Opened on'),
                    subtitle: Text(
                      openedOnDate == null
                          ? 'Not set'
                          : '${openedOnDate!.day}.${openedOnDate!.month}.${openedOnDate!.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: openedOnDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setDialogState(() {
                          openedOnDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
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
                    final name = nameController.text.trim();
                    final quantity = double.tryParse(quantityController.text.trim());
                    final unit = unitController.text.trim();

                    if (name.isEmpty || unit.isEmpty || quantity == null) {
                      return;
                    }

                    final item = Item(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      owner: widget.compartment.owner,
                      quantity: quantity,
                      unit: unit,
                      expirationDate: expirationDate,
                      openedOnDate: openedOnDate,
                      compartmentId: widget.compartment.id,
                    );

                    await widget.itemRepository.addItem(item);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    if (mounted) {
                      setState(() {});
                    }
              },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      }
    );
  }

  void _showEditItemDialog(Item item) {
    final nameController = TextEditingController(
      text: item.name,
    );

    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );

    final unitController = TextEditingController(
      text: item.unit,
    );
    DateTime? expirationDate = item.expirationDate;
    DateTime? openedOnDate = item.openedOnDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                  ),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Expiration date'),
                    subtitle: Text(
                      expirationDate == null
                          ? 'Not set'
                          : '${expirationDate!.day}.${expirationDate!.month}.${expirationDate!.year}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: expirationDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              setDialogState(() {
                                expirationDate = pickedDate;
                              });
                            }
                          },
                        ),
                        if (expirationDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setDialogState(() {
                                expirationDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Opened on date'),
                    subtitle: Text(
                      openedOnDate == null
                          ? 'Not set'
                          : '${openedOnDate!.day}.${openedOnDate!.month}.${openedOnDate!.year}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: openedOnDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              setDialogState(() {
                                openedOnDate = pickedDate;
                              });
                            }
                          },
                        ),
                        if (openedOnDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setDialogState(() {
                                expirationDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ],
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
                    final name = nameController.text.trim();
                    final quantity = double.tryParse(
                      quantityController.text.trim(),
                    );
                    final unit = unitController.text.trim();

                    if (name.isEmpty || unit.isEmpty || quantity == null) {
                      return;
                    }

                    final updatedItem = Item(
                      id: item.id,
                      name: name,
                      owner: item.owner,
                      quantity: quantity,
                      unit: unit,
                      expirationDate: expirationDate,
                      openedOnDate: openedOnDate,
                      compartmentId: item.compartmentId,
                    );

                    await widget.itemRepository.updateItem(
                      updatedItem,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final compartmentItems = widget.itemRepository.items
      .where(
        (item) => item.compartmentId == widget.compartment.id,
      )
      .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.compartment.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (compartmentItems.isEmpty)
            const Text('No items yet'),

          ...compartmentItems.map(
            (item) => ListTile(
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.quantity} ${item.unit}'),

                  if (item.expirationDate != null)
                    Text(
                      'Expires: ${item.expirationDate!.day}.${item.expirationDate!.month}.${item.expirationDate!.year}',
                    ),

                  if (item.openedOnDate != null)
                    Text(
                      'Opened: ${item.openedOnDate!.day}.${item.openedOnDate!.month}.${item.openedOnDate!.year}',
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditItemDialog(item);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete item?'),
                            content: Text(
                              'Are you sure you want to delete "${item.name}"?',
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
                        await widget.itemRepository.deleteItem(item.id);

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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  _showAddItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}