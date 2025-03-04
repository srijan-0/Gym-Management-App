import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/app/shared_prefs/token_shared_prefs.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';
import 'package:login/features/auth/domain/use_case/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUpAll(() {
    registerFallbackValue(ApiFailure(message: "API Failure"));
    registerFallbackValue(
        LocalDatabaseFailure(message: "Local Database Failure"));
    registerFallbackValue(
        SharedPrefsFailure(message: "Shared Preferences Failure"));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    loginUseCase = LoginUseCase(mockAuthRepository, mockTokenSharedPrefs);
  });

  const testEmail = "test@example.com";
  const testPassword = "password123";
  const testToken = "dummy_token";

  final testParams = LoginParams(email: testEmail, password: testPassword);

  test(' should return token when login is successful and token is saved',
      () async {
    when(() => mockAuthRepository.logincustomer(any(), any()))
        .thenAnswer((_) async => Future.value(Right(testToken)));

    when(() => mockTokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => Future.value(Right(unit)));

    final result = await loginUseCase(testParams);

    expect(result, Right(testToken));

    verify(() => mockAuthRepository.logincustomer(testEmail, testPassword))
        .called(1);
    verify(() => mockTokenSharedPrefs.saveToken(testToken)).called(1);
  });

  test('should return ApiFailure when login fails', () async {
    when(() => mockAuthRepository.logincustomer(any(), any())).thenAnswer(
        (_) async => Future.value(Left(ApiFailure(message: "API Error"))));

    final result = await loginUseCase(testParams);

    expect(result, Left(ApiFailure(message: "API Error")));

    verify(() => mockAuthRepository.logincustomer(testEmail, testPassword))
        .called(1);
    verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
  });

  test('should return token even if saving token fails', () async {
    when(() => mockAuthRepository.logincustomer(any(), any()))
        .thenAnswer((_) async => Future.value(Right(testToken)));

    when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer((_) async =>
        Future.value(
            Left(SharedPrefsFailure(message: "Failed to save token"))));

    final result = await loginUseCase(testParams);

    expect(result, Right(testToken));

    verify(() => mockAuthRepository.logincustomer(testEmail, testPassword))
        .called(1);
    verify(() => mockTokenSharedPrefs.saveToken(testToken)).called(1);
  });

  test('should return LocalDatabaseFailure when login fails', () async {
    when(() => mockAuthRepository.logincustomer(any(), any())).thenAnswer(
        (_) async => Future.value(
            Left(LocalDatabaseFailure(message: "Local Database Error"))));

    final result = await loginUseCase(testParams);

    expect(result, Left(LocalDatabaseFailure(message: "Local Database Error")));

    verify(() => mockAuthRepository.logincustomer(testEmail, testPassword))
        .called(1);
    verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
  });
}
