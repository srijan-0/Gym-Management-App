import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:login/app/shared_prefs/token_shared_prefs.dart';

import '../../../../app/use_case/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final result =
        await repository.logincustomer(params.email, params.password);
    return result.fold(
      (failure) => Left(failure),
      (token) async {
        // Await saving the token
        return Right(token);
      },
    );
  }
}
