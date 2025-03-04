import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/use_case/login_usecase.dart';
import 'package:login/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:login/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:login/features/home/presentation/view_model/home_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFailure extends Mock implements Failure {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late LoginBloc loginBloc;
  late MockRegisterBloc mockRegisterBloc;
  late MockHomeCubit mockHomeCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockBuildContext mockContext;
  late MockFailure mockFailure;

  setUp(() {
    mockRegisterBloc = MockRegisterBloc();
    mockHomeCubit = MockHomeCubit();
    mockLoginUseCase = MockLoginUseCase();
    mockContext = MockBuildContext();
    mockFailure = MockFailure();

    loginBloc = LoginBloc(
      registerBloc: mockRegisterBloc,
      homeCubit: mockHomeCubit,
      loginUseCase: mockLoginUseCase,
    );

    registerFallbackValue(
        LoginParams(email: 'test@example.com', password: 'password'));
  });

  tearDown(() {
    loginBloc.close();
  });
  blocTest<LoginBloc, LoginState>(
    'Emits failure state when login fails',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Left(mockFailure));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LogincustomerEvent(
        context: mockContext,
        email: 'wrong@example.com',
        password: 'wrongpassword',
      ),
    ),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true),
      LoginState.initial().copyWith(isLoading: false, isSuccess: false),
    ],
    verify: (_) {
      verifyNever(() => Navigator.pushReplacement(any(), any()));
    },
  );

  blocTest<LoginBloc, LoginState>(
    'Emits success state when login succeeds and prevents navigation error',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => Right("mock_token"));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LogincustomerEvent(
        context: mockContext,
        email: 'test@example.com',
        password: 'password',
      ),
    ),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true),
      LoginState.initial().copyWith(isLoading: false, isSuccess: true),
    ],
    verify: (_) {
      verifyNever(() => Navigator.pushReplacement(any(), any()));
    },
  );
}
