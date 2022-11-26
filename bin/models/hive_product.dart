import 'package:hive/hive.dart';

part 'hive_product.g.dart';

@HiveType(typeId: 0)
class HiveProduct extends HiveObject {
  @HiveField(0)
  String receiptName;

  @HiveField(1)
  String eanName;

  @HiveField(2)
  double? price;

  @HiveField(3)
  String? eanCode;

  HiveProduct({
    required this.receiptName,
    required this.eanName,
    this.price,
    this.eanCode,
  });

  @override
  String toString() {
    return 'receiptName: $receiptName, '
        'eanName: $eanName, '
        'price: ${price ?? 'not set'}, '
        'eanCode: ${eanCode ?? 'not set'}';
  }
}
