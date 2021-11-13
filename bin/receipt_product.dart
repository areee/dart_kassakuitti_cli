class ReceiptProduct {
  final String? name;
  final String? totalPrice;
  int? quantity;
  String? pricePerUnit;

  ReceiptProduct({
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
