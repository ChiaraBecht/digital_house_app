import 'package:digital_house/repositories/item_repository.dart';
import '../models/compartment.dart';
import 'package:flutter/material.dart';

class CompartmentScreen extends StatefulWidget {
  final Compartment compartment;
  final ItemRepository itemRepository;

  const CompartmentScreen({
    super.key,
    required this.compartment,
    required this.itemRepository,
  });

  @override
  State<CompartmentScreen> createState() => _CompartmentScreenState();
}

class _CompartmentScreenState extends State<CompartmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.compartment.name),
      ),
      body: const Center(
        child: Text('Items will go here'),
      ),
    );
  }
}