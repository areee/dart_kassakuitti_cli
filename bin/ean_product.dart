class EANProduct {
  final String ean;
  final String name;
  final int quantity;

  EANProduct({required this.ean, required this.name, required this.quantity});

  @override
  String toString() {
    return 'EANProduct{ean: $ean, name: $name, quantity: $quantity}';
  }
}
