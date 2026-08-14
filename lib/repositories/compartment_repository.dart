import '../models/compartment.dart';

class CompartmentRepository {
  final List<Compartment> compartments = [
    Compartment(
      id: 'fridge-top',
      name: 'Top shelf',
      owner: 'Everyone',
      storageUnitId: 'fridge',
    ),
    Compartment(
      id: 'pantry-baking',
      name: 'Baking',
      owner: 'Everyone',
      storageUnitId: 'pantry',
    ),
  ];

  void addCompartment(Compartment compartment) {
    compartments.add(compartment);
  }
}