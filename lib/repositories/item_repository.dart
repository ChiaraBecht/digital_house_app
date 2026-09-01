import '../models/item.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ItemRepository {
  List<Item> items = [];

  static const String _itemsKey = 'items';

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();

    final itemsJson = jsonEncode(
      items.map((item) {
        return {
          'id': item.id,
          'name': item.name,
          'owner': item.owner,
          'quantity': item.quantity,
          'unit': item.unit,
          'expirationDate': item.expirationDate?.toIso8601String(),
          'openedOnDate': item.openedOnDate?.toIso8601String(),
          'compartmentId': item.compartmentId,
        };
      }).toList(),
    );

    await prefs.setString(
      _itemsKey,
      itemsJson,
    );
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();

    final itemsJson = prefs.getString(_itemsKey);

    if (itemsJson == null) {
      items = [];
      return;
    }

    // decode saved items here
    final decodedItems = jsonDecode(itemsJson);
    items = decodedItems.map<Item>((item) {
      return Item(
        id: item['id'],
        name: item['name'],
        owner: item['owner'],
        quantity: (item['quantity'] as num).toDouble(),
        unit: item['unit'],
        expirationDate: item['expirationDate'] == null ? null : DateTime.parse(item['expirationDate']),
        openedOnDate: item['openedOnDate'] == null ? null : DateTime.parse(item['openedOnDate']),
        compartmentId: item['compartmentId'],
      );
    }).toList();
  }

  Future<void> addItem(Item item) async {
    // 1. change in-memory list
    items.add(item);
    // 2. persist
    await saveItems();
  }

  Future<void> updateItem(Item updatedItem) async {
    final index = items.indexWhere(
      (item) => item.id == updatedItem.id,
    );

    // What if index is -1?
    if (index == -1) {
      return;
    }

    // Replace the item at index
    items[index] = updatedItem;

    // Persist the change
    await saveItems();
  }

  Future<void> deleteItem(String id) async {
    // remove matching item
    items.removeWhere((item) => item.id == id);
    // persist updated list
    await saveItems();
  }
}