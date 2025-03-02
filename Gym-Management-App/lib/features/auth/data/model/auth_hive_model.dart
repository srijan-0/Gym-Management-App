import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:login/app/constants/hive_table_constant.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entity/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.customerTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String? userImage;
  @HiveField(5)
  final String cPassword; // Added confirm password

  AuthHiveModel({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
    this.userImage,
    required this.cPassword, // Ensure confirm password is also passed
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : userId = '',
        name = '',
        email = '',
        password = '',
        userImage = '',
        cPassword = ''; // Initialize confirm password as empty

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity, String cPassword) {
    return AuthHiveModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      userImage: entity.userImage,
      cPassword: cPassword, // Passing confirm password here
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      name: name,
      email: email,
      password: password,
      userImage: userImage,
      cPassword: cPassword,
    );
  }

  @override
  List<Object?> get props =>
      [userId, name, email, password, userImage, cPassword];
}
