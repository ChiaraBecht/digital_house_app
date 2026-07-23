import 'package:flutter/material.dart';
import '../screens/kitchen_screen.dart';

final Map<String, WidgetBuilder> roomRoutes = {
  'kitchen': (context) => const KitchenScreen(),
};