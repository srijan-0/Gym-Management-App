import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String password;
  final String? userImage;
  final String cPassword; // Add cPassword field

  const AuthEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.cPassword, // Make cPassword required
    this.userImage,
  });

  @override
  List<Object?> get props =>
      [userId, name, email, password, userImage, cPassword];

  get token => null;
}
