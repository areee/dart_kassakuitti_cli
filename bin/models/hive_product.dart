import 'package:hive/hive.dart';

part 'hive_product.g.dart';

@HiveType(typeId: 0)
class HiveProduct extends HiveObject {
  @HiveField(0)
  String receiptName;

  @HiveField(1)
  String eanName;

  HiveProduct({required this.receiptName, required this.eanName});

  @override
  String toString() {
    return 'ReceiptName: $receiptName, eanName: $eanName';
  }
}
