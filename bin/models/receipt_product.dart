class ReceiptProduct {
  String name;
  String totalPrice;
  int quantity;
  String pricePerUnit;
  // TODO: In the future, this should include an EAN code for a receipt product.
  String eanCode;
  String discountCounted;

  ReceiptProduct({
    this.name = 'Default receipt product name',
    this.totalPrice = '0',
    this.quantity = 1,
    this.pricePerUnit = '',
    this.eanCode = '',
    this.discountCounted = '',
  });

  @override
  String toString() {
    return 'Product{name: $name, totalPrice: $totalPrice, quantity: $quantity, pricePerUnit: $pricePerUnit, eanCode: $eanCode, discountCounted: $discountCounted}';
  }
}
