class EANProduct {
  final String ean;
  final String name;
  final int quantity;
  final String price;

  EANProduct(
      {required this.ean,
      required this.name,
      required this.quantity,
      required this.price});

  @override
  String toString() {
    return 'EANProduct{ean: $ean, name: $name, quantity: $quantity, price: $price}';
  }
}
