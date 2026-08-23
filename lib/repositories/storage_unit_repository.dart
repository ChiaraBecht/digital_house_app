import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/storage_unit.dart';

class StorageUnitRepository {
  List<StorageUnit> storageUnits = [];

  static const String _storageUnitsKey = 'storage_units';

  Future<void> loadStorageUnits() async {
    final prefs = await SharedPreferences.getInstance();

    final storageUnitsJson = prefs.getString(_storageUnitsKey);

    if (storageUnitsJson == null) {
      storageUnits = [
        const StorageUnit(
          id: 'pantry',
          name: 'Pantry',
          type: 'cupboard',
          icon: '🗄️',
          roomId: 'kitchen',
        ),
        const StorageUnit(
          id: 'fridge',
          name: 'Fridge',
          type: 'Fridge',
          icon: '🧊',
          roomId: 'kitchen',
        ),
      ];

      await saveStorageUnits();
      return;
    }

    final decodedStorageUnits = jsonDecode(storageUnitsJson);

    storageUnits = decodedStorageUnits.map<StorageUnit>((storageUnit) {
      return StorageUnit(
        id: storageUnit['id'],
        name: storageUnit['name'],
        type: storageUnit['type'],
        icon: storageUnit['icon'],
        roomId: storageUnit['roomId'],
      );
    }).toList();
  }

  Future<void> saveStorageUnits() async {
    final prefs = await SharedPreferences.getInstance();

    final storageUnitsJson = jsonEncode(
      storageUnits.map((storageUnit) {
        return {
          'id': storageUnit.id,
          'name': storageUnit.name,
          'type': storageUnit.type,
          'icon': storageUnit.icon,
          'roomId': storageUnit.roomId,
        };
      }).toList(),
    );

    await prefs.setString(
      _storageUnitsKey,
      storageUnitsJson,
      );
  }

  Future<void> addStorageUnit(StorageUnit storageUnit) async {
    storageUnits.add(storageUnit);
    await saveStorageUnits();
  }

  Future<void> updateStorageUnit(String id, String newName,) async {
    final index = storageUnits.indexWhere(
      (storageUnit) => storageUnit.id == id,
    );

    if (index == -1) {
      return;
    }

    final storageUnit = storageUnits[index];
    
    storageUnits[index] = StorageUnit(
      id: storageUnit.id,
      name: newName,
      type: storageUnit.type,
      icon: storageUnit.icon,
      roomId: storageUnit.roomId,
    );

    await saveStorageUnits();
  }

  Future<void> deleteStorageUnit(String id) async {
    storageUnits.removeWhere(
      (storageUnit) => storageUnit.id == id,
    );

    await saveStorageUnits();
  }
}

