import 'package:flutter/material.dart';
import '../screens/rooms_screen.dart';

final Map<String, WidgetBuilder> roomRoutes = {
  'kitchen': (context) => const RoomScreen(),
};