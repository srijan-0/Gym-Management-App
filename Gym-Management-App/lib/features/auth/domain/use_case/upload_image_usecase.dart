import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:login/app/use_case/usecase.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';



class UploadImageParams {
  final File file;

  const UploadImageParams({
    required this.file,
  });
}

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final IAuthRepository _repository;

  UploadImageUsecase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) {
    return _repository.uploadProfilePicture(params.file);
  }

  // @override
  // Future<Either<Failure, String>> call(UploadImageParams params) {
  //   return _repository.uploadProfilePicture(params.file);
  // }
}
