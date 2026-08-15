import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/room.dart';

class RoomRepository {
  List<Room> rooms = [];

  static const String _roomsKey = 'rooms';

  Future<void> loadRooms() async {
    final prefs = await SharedPreferences.getInstance();

    final roomsJson = prefs.getString(_roomsKey);

    if (roomsJson == null) {
      rooms = [
        const Room(
          id: 'kitchen',
          name: 'Kitchen',
          type: 'Kitchen',
          icon: '🍳',
        ),
        const Room(
          id: 'bathroom',
          name: 'Bathroom',
          type: 'Bathroom',
          icon: '🚿',
        ),
      ];

      await saveRooms();
      return;
    }

    final List<dynamic> decodedRooms = jsonDecode(roomsJson);

    rooms = decodedRooms.map((room) {
      return Room(
        id: room['id'],
        name: room['name'],
        type: room['type'],
        icon: room['icon'],
      );
    }).toList();
  }

  Future<void> saveRooms() async {
    final prefs = await SharedPreferences.getInstance();

    final roomsJson = jsonEncode(
      rooms.map((room) {
        return {
          'id': room.id,
          'name': room.name,
          'type': room.type,
          'icon': room.icon,
        };
      }).toList(),
    );

    await prefs.setString(_roomsKey, roomsJson);

  }
  Future<void> addRoom(Room room) async {
  rooms.add(room);
  await saveRooms();
  }
}