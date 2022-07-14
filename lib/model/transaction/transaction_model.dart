import 'package:budfi/model/category/category_model.dart';
import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String notes;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  categorytype type;
  @HiveField(4)
  final String id;
  @HiveField(5)
  final CategoryModel category;

  TransactionModel({
    required this.notes,
    required this.amount,
    required this.dateTime,
    required this.type,
    required this.id,
    required this.category,
  });
}

@HiveType(typeId: 2)
enum categorytype {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
