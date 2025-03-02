// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:login/core/error/failure.dart';
// import 'package:login/features/auth/domain/use_case/login_usecase.dart';
// import 'package:login/features/auth/domain/use_case/repository.mock.dart';
// import 'package:login/features/auth/domain/use_case/token.mock.dart';
// import 'package:mocktail/mocktail.dart';

// void main() {
//   late MockBatchRepository mockAuthRepository;
//   late MockTokenSharedPrefs mockTokenSharedPrefs;
//   late LoginUseCase loginUseCase;

//   setUp(() {
//     mockAuthRepository = MockBatchRepository();
//     mockTokenSharedPrefs = MockTokenSharedPrefs();
//     loginUseCase = LoginUseCase(mockAuthRepository, mockTokenSharedPrefs);

//     registerFallbackValue(LoginParams(username: '', password: ''));
//   });

//   group('LoginUseCase', () {
//     test('Should save token when login is successful', () async {
//       const params = LoginParams(username: 'srijan', password: 'srijan');
//       const mockToken = 'sample_token';

//       when(() => mockAuthRepository.logincustomer(
//               params.username, params.password))
//           .thenAnswer((_) async => const Right(mockToken));

//       when(() => mockTokenSharedPrefs.saveToken(mockToken))
//           .thenAnswer((_) async => Right(unit));

//       final result = await loginUseCase(params);

//       expect(result, equals(const Right(mockToken)));

//       verify(() => mockAuthRepository.logincustomer(
//           params.username, params.password)).called(1);
//       verify(() => mockTokenSharedPrefs.saveToken(mockToken)).called(1);
//     });

//     test('Should return ApiFailure when login fails', () async {
//       const params = LoginParams(username: 'testuser', password: 'wrongpass');

//       when(() => mockAuthRepository.logincustomer(
//               params.username, params.password))
//           .thenAnswer((_) async =>
//               Left(ApiFailure(message: 'Login failed due to server error')));

//       final result = await loginUseCase(params);

//       expect(result, isA<Left>());
//       expect(
//           result,
//           equals(
//               Left(ApiFailure(message: 'Login failed due to server error'))));

//       verify(() => mockAuthRepository.logincustomer(
//           params.username, params.password)).called(1);
//       verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
//     });

//     test(
//       'Should retrieve the token from shared preferences after successful login',
//       () async {
//         const params = LoginParams(username: 'srijan', password: 'srijan');
//         const mockToken = 'sample_token';

//         when(() => mockAuthRepository.logincustomer(
//                 params.username, params.password))
//             .thenAnswer((_) async => const Right(mockToken));

//         when(() => mockTokenSharedPrefs.saveToken(mockToken))
//             .thenAnswer((_) async => Right(unit));

//         when(() => mockTokenSharedPrefs.getToken())
//             .thenAnswer((_) async => Right(mockToken));

//         final result = await loginUseCase(params);

//         expect(result, equals(const Right(mockToken)));

//         verify(() => mockAuthRepository.logincustomer(
//             params.username, params.password)).called(1);

//         verify(() => mockTokenSharedPrefs.saveToken(mockToken)).called(1);

//         verify(() => mockTokenSharedPrefs.getToken()).called(1);
//       },
//     );
//   });
// }
