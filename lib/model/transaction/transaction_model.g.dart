// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      notes: fields[0] as String,
      amount: fields[1] as double,
      dateTime: fields[2] as DateTime,
      type: fields[3] as categorytype,
      id: fields[4] as String,
      category: fields[5] as CategoryModel,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.notes)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class categorytypeAdapter extends TypeAdapter<categorytype> {
  @override
  final int typeId = 2;

  @override
  categorytype read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return categorytype.income;
      case 1:
        return categorytype.expense;
      default:
        return categorytype.income;
    }
  }

  @override
  void write(BinaryWriter writer, categorytype obj) {
    switch (obj) {
      case categorytype.income:
        writer.writeByte(0);
        break;
      case categorytype.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is categorytypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
