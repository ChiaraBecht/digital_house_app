import 'package:flutter/material.dart';
import '../models/room.dart';
import '../data/storage_units.dart';

class RoomScreen extends StatelessWidget {
  final Room room;

  const RoomScreen({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    final roomStorageUnits = storageUnits
      .where((unit) => unit.roomId == room.id)
      .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${room.icon} ${room.name}'),
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
                trailing: const Icon(Icons.chevron_right),
                onTap: null,
              ))
          ),
          ],
        ),
      ),
    );
  }
}