import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/app_user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
    );
  }
}
