import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 4)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String categoryname;
  @HiveField(2)
  final categorytype type;

  CategoryModel({
    required this.id,
    required this.categoryname,
    required this.type,
  });
}
