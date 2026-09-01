class Item {
  final String id;
  final String name;
  final String owner;
  final double quantity;
  final String unit;
  final DateTime? expirationDate;
  final DateTime? openedOnDate;
  final String compartmentId;

  const Item({
    required this.id,
    required this.name,
    required this.owner,
    required this.quantity,
    required this.unit,
    this.expirationDate,
    this.openedOnDate,
    required this.compartmentId,
  });
}