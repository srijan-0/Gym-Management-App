import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:login/app/shared_prefs/token_shared_prefs.dart';

import '../../../../app/use_case/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : username = '',
        password = '';

  @override
  List<Object> get props => [username, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result =
        await repository.logincustomer(params.username, params.password);
    return result.fold(
      (failure) => Left(failure),
      (token) async {
        // Await saving the token
        final saveResult = await tokenSharedPrefs.saveToken(token);
        return Right(token);
      },
    );
  }
}
