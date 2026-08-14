import 'package:digital_house/repositories/compartment_repository.dart';
import 'package:flutter/material.dart';
import '../models/storage_unit.dart';

class StorageUnitScreen extends StatelessWidget {
  final StorageUnit storageUnit;
  final CompartmentRepository compartmentRepository;

  const StorageUnitScreen({
    super.key,
    required this.storageUnit,
    required this.compartmentRepository,
  });

  @override
  Widget build(BuildContext context) {
    final storageUnitCompartments =
      compartmentRepository.compartments
          .where(
            (compartment) =>
                compartment.storageUnitId == storageUnit.id,
          )
          .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${storageUnit.icon} ${storageUnit.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storageUnit.name,
              style: const TextStyle(fontSize: 30),
              ),
            Text('Type: ${storageUnit.type}'),
            const SizedBox(height: 30),
            Text(
              "Compartments",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
              ),
            const SizedBox(height: 10),
            if (storageUnitCompartments.isEmpty)
              const Text('No compartments yet'),

            ...storageUnitCompartments.map(
              (compartment) => Card(
                child: ListTile(
                  title: Text(compartment.name),
                  subtitle: Text('Owner: ${compartment.owner}'),
                ),
              ),
            ),
          ],
        )
      ),
      );
  }
}