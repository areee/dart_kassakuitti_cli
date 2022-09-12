class EANProduct {
  final String eanCode;
  final String name;
  final int quantity;
  final String totalPrice;
  final String pricePerUnit;
  final String moreDetails;

  EANProduct(
      {this.eanCode = '0000000000000',
      this.name = 'Default EAN product name',
      this.quantity = 1,
      this.totalPrice = '0',
      this.pricePerUnit = '',
      this.moreDetails = ''});

  @override
  String toString() {
    return '$quantity x $name${quantity > 1 ? ' ($pricePerUnit e / pcs)' : ''} = $totalPrice e';
  }
}
