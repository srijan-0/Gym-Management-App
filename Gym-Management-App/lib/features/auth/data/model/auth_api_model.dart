import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:login/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? userImage;
  final String email;
  final String? password;
  final String? cPassword; // Added confirm password field

  const AuthApiModel({
    this.id,
    required this.name,
    required this.userImage,
    required this.email,
    required this.password,
    this.cPassword, // Include cPassword here
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      name: name,
      userImage: userImage,
      email: email,
      password: password ?? '',
      cPassword: cPassword ?? '', // Handle null values, if any
    );
  }

  // From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      name: entity.name,
      userImage: entity.userImage,
      email: entity.email,
      password: entity.password,
      cPassword: '', // You might handle cPassword separately, if needed
    );
  }

  @override
  List<Object?> get props => [id, name, userImage, email, password, cPassword];
}
