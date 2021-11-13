class EANProduct {
  final String ean;
  final String name;

  EANProduct({required this.ean, required this.name});

  @override
  String toString() {
    return 'EANProduct{ean: $ean, name: $name}';
  }
}
