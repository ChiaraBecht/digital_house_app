import '../models/storage_unit.dart';

class StorageUnitRepository {
  final List<StorageUnit> storageUnits = [
    StorageUnit(
      id: 'pantry',
      name: 'Pantry',
      type: 'cupboard',
      icon: '🗄️',
      roomId: 'kitchen',
    ),
    StorageUnit(
      id: 'fridge',
      name: 'Fridge',
      type: 'Fridge',
      icon: '🧊',
      roomId: 'kitchen',
    ),
  ];

  void addStorageUnit(StorageUnit storageUnit) {
    storageUnits.add(storageUnit);
  }
}