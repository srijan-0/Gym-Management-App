import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:login/features/auth/domain/use_case/register_user_usecase.dart';

import '../../../../core/error/failure.dart';
import '../entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registercustomer(AuthEntity customer);

  Future<Either<Failure, String>> logincustomer(
      String username, String password);

  Future<Either<Failure, String>> uploadProfilePicture(File file);

  Future<Either<Failure, AuthEntity>> getCurrentUser();

  register(RegisterUserParams params) {}
}
