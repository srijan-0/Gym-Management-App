import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:login/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseUseCase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

void main() {
  late RegisterBloc registerBloc;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockUploadImageUsecase mockUploadImageUsecase;

  setUpAll(() {
    registerFallbackValue(const RegisterUserParams.initial());
  });

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    mockUploadImageUsecase = MockUploadImageUsecase();
    registerBloc = RegisterBloc(
      registerUseCase: mockRegisterUseCase,
      uploadImageUsecase: mockUploadImageUsecase,
    );
  });

  tearDown(() {
    registerBloc.close();
  });

  group('RegisterBloc Tests', () {
    const registerParams = RegisterUserParams(
      name: "John Doe",
      email: "john.doe@example.com",
      password: "password123",
      cPassword: "password123",
      userImage: "profile.png",
    );

    test('Initial state should be RegisterState.initial()', () {
      expect(registerBloc.state, equals(const RegisterState.initial()));
    });

    blocTest<RegisterBloc, RegisterState>(
      ' should emit [loading, failure] when registration fails',
      build: () {
        when(() => mockRegisterUseCase.call(any()))
            .thenAnswer((_) async => const Left(ApiFailure(message: "Error")));
        return registerBloc;
      },
      act: (bloc) => bloc.add(Registercustomer(
        context: FakeBuildContext(),
        name: registerParams.name,
        email: registerParams.email,
        password: registerParams.password,
        cPassword: registerParams.cPassword,
        userImage: registerParams.userImage,
      )),
      expect: () => [
        const RegisterState(isLoading: true, isSuccess: false),
        const RegisterState(isLoading: false, isSuccess: false),
      ],
    );
  });
}

class FakeBuildContext extends Fake implements BuildContext {}
