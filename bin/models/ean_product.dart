class EANProduct {
  final String ean;
  final String name;
  final int quantity;
  final String totalPrice;
  final String pricePerUnit;
  final String moreDetails;

  EANProduct(
      {this.ean = '0000000000000',
      this.name = 'Default EAN product name',
      this.quantity = 1,
      this.totalPrice = '0',
      this.pricePerUnit = '',
      this.moreDetails = ''});

  @override
  String toString() {
    return 'EANProduct{ean: $ean, name: $name, quantity: $quantity,'
        ' price: $totalPrice, pricePerUnit: $pricePerUnit,'
        ' moreDetails: $moreDetails}';
  }
}
