class Product {
  final String? name;
  final String? totalPrice;
  int? quantity;
  String? pricePerUnit;

  Product({
    this.name,
    this.totalPrice,
    this.quantity = 1,
    this.pricePerUnit = '',
  });

  @override
  String toString() {
    return 'Product{name: $name, totalPrice: $totalPrice, quantity: $quantity, pricePerUnit: $pricePerUnit}';
  }
}
