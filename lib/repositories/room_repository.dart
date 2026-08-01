import '../models/room.dart';

class RoomRepository {
  final List<Room> rooms = [
    Room(
      id: 'kitchen',
      name: 'Kitchen',
      icon: '🍳',
    ),
    Room(
      id: 'bathroom',
      name: 'Bathroom',
      icon: '🚿',
    ),
  ];
  void addRoom(Room room) {
  rooms.add(room);
  print('There are now ${rooms.length} rooms.');
}
}