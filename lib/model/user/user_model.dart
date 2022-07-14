import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserModel extends HiveObject {
  @HiveField(1)
  final String username;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  String? imagePath;

  UserModel(
      {required this.imagePath, required this.username, required this.amount});
}
