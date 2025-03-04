import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/entity/auth_entity.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String cPassword;
  final String? userImage;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
    required this.cPassword,
    this.userImage,
  });

  // Initial Constructor
  const RegisterUserParams.initial()
      : name = '',
        email = '',
        password = '',
        cPassword = '', // Add initial value for confirmPassword
        userImage = '';

  @override
  List<Object?> get props => [name, email, password, cPassword, userImage];
}

class RegisterUseUseCase {
  final IAuthRepository _authRepository;

  // Constructor to inject the repository
  RegisterUseUseCase(this._authRepository);

  Future<Either<Failure, AuthEntity>> call(RegisterUserParams params) async {
    // We call the repository's register method and pass the params
    return await _authRepository.register(params);
  }
}

// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:login/core/error/failure.dart';
// import 'package:login/core/network/network_service.dart';
// import 'package:login/features/auth/domain/entity/auth_entity.dart';
// import 'package:login/features/auth/domain/repository/auth_repository.dart';

// class RegisterUserParams extends Equatable {
//   final String name;
//   final String email;
//   final String password;
//   final String cPassword;
//   final String? userImage;

//   const RegisterUserParams({
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.cPassword,
//     this.userImage,
//   });

//   const RegisterUserParams.initial()
//       : name = '',
//         email = '',
//         password = '',
//         cPassword = '',
//         userImage = '';

//   @override
//   List<Object?> get props => [name, email, password, cPassword, userImage];
// }

// class RegisterUseCase {
//   final IAuthRepository _authRepository;

//   RegisterUseCase(this._authRepository);

//   Future<Either<Failure, AuthEntity>> call(RegisterUserParams params) async {
//     bool isOnline = await NetworkService.isOnline();

//     if (isOnline) {
//       return await _authRepository.register(params);
//     } else {
//       return Left(LocalDatabaseFailure(
//           message: "No Internet. Registration saved locally."));
//     }
//   }
// }
