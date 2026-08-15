import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/compartment.dart';

class CompartmentRepository {
  List<Compartment> compartments = [];

  static const String _compartmentsKey = 'compartments';

  Future<void> loadCompartments() async {
    final prefs = await SharedPreferences.getInstance();

    final compartmentsJson = prefs.getString(_compartmentsKey);

    if (compartmentsJson == null) {
      compartments = [
        const Compartment(
          id: 'fridge-top',
          name: 'Top shelf',
          owner: 'Everyone',
          storageUnitId: 'fridge',
        ),
        const Compartment(
          id: 'pantry-baking',
          name: 'Baking',
          owner: 'Everyone',
          storageUnitId: 'pantry',
        ),
      ];

      await saveCompartments();
      return;
    }

    final decodedCompartments = jsonDecode(compartmentsJson);

    compartments =
        decodedCompartments.map<Compartment>((compartment) {
      return Compartment(
        id: compartment['id'],
        name: compartment['name'],
        owner: compartment['owner'],
        storageUnitId: compartment['storageUnitId'],
      );
    }).toList();
  }

  Future<void> saveCompartments() async {
    final prefs = await SharedPreferences.getInstance();

    final compartmentsJson = jsonEncode(
      compartments.map((compartment) {
        return {
          'id': compartment.id,
          'name': compartment.name,
          'owner': compartment.owner,
          'storageUnitId': compartment.storageUnitId,
        };
      }).toList(),
    );

    await prefs.setString(
      _compartmentsKey,
      compartmentsJson,
    );
  }

  Future<void> addCompartment(Compartment compartment) async {
    compartments.add(compartment);
    await saveCompartments();
  }
}