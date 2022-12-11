// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductAdapter extends TypeAdapter<HiveProduct> {
  @override
  final int typeId = 0;

  @override
  HiveProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProduct(
      receiptName: fields[0] as String,
      eanName: fields[1] as String,
      price: fields[2] as double?,
      eanCode: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveProduct obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.receiptName)
      ..writeByte(1)
      ..write(obj.eanName)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.eanCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
