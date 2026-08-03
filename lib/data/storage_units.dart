import '../models/storage_unit.dart';

final storageUnits = [
  StorageUnit(
    id: 'fridge',
    name: 'Fridge',
    type: 'Fridge',
    icon: '🧊',
    roomId: 'kitchen'),
  StorageUnit(
    id: 'pantry',
    name: 'Pantry',
    type: 'cupboard',
    icon: '🥫',
    roomId: 'kitchen'
  ),
];