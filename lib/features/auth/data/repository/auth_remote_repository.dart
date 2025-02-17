import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:login/features/auth/domain/entity/auth_entity.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';
import 'package:login/features/auth/domain/use_case/register_user_usecase.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDataSource;
  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> logincustomer(
      String username, String password) async {
    try {
      final token =
          await _authRemoteDataSource.logincustomer(username, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registercustomer(AuthEntity customer) async {
    try {
      await _authRemoteDataSource.registercustomer(customer);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _authRemoteDataSource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(
      RegisterUserParams params) async {
    try {
      // Map the RegisterUserParams to AuthEntity or call the appropriate data source method
      final AuthEntity customer = AuthEntity(
        userId: "", // Assign userId based on your registration logic
        name: params.name,
        email: params.email,
        password: params.password,
        cPassword: params.cPassword,
        userImage: params.userImage ?? "", // Handle optional userImage
      );

      await _authRemoteDataSource.registercustomer(customer);

      return Right(
          customer); // Return the customer entity if registration is successful
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
