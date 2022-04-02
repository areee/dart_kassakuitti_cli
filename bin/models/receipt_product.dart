class ReceiptProduct {
  String name;
  String totalPrice;
  int quantity;
  String pricePerUnit;
  String discountCounted;

  ReceiptProduct({
    this.name = 'Default receipt product name',
    this.totalPrice = '0',
    this.quantity = 1,
    this.pricePerUnit = '',
    this.discountCounted = '',
  });

  @override
  String toString() {
    return 'Product{name: $name, totalPrice: $totalPrice, quantity: $quantity, pricePerUnit: $pricePerUnit, discountCounted: $discountCounted}';
  }
}
