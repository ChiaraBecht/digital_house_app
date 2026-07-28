import 'package:flutter/material.dart';
import '../models/storage_unit.dart';

class StorageUnitScreen extends StatelessWidget {
  final StorageUnit storageUnit;

  const StorageUnitScreen({
    super.key,
    required this.storageUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${storageUnit.icon} ${storageUnit.name}'),
      ),
      body: Center(
        child: Text(
          storageUnit.name,
          style: const TextStyle(fontSize: 30)
          ),
        ),
      );
  }
}