import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:login/features/auth/domain/entity/auth_entity.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDataSource;
  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> logincustomer(
      String username, String password) async{
    try {
      final token = await _authRemoteDataSource.logincustomer(username, password);
      return Right(token);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
    
  }

  @override
  Future<Either<Failure, void>> registercustomer(AuthEntity customer)async {
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
}
