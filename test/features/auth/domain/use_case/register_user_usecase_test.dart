// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:login/core/error/failure.dart';
// import 'package:login/features/auth/domain/entity/auth_entity.dart';
// import 'package:login/features/auth/domain/repository/auth_repository.dart';
// import 'package:login/features/auth/domain/use_case/register_user_usecase.dart';
// import 'package:mocktail/mocktail.dart';

// // Create a mock class for IAuthRepository using mocktail
// class MockAuthRepository extends Mock implements IAuthRepository {}

// void main() {
//   late RegisterUseCase registerUseCase;
//   late MockAuthRepository mockAuthRepository;

//   setUp(() {
//     mockAuthRepository = MockAuthRepository();
//     registerUseCase = RegisterUseCase(mockAuthRepository);
//   });

//   group('RegisterUseCase', () {
//     // Define a common set of parameters for registration
//     const params = RegisterUserParams(
//       fname: 'John',
//       lname: 'Doe',
//       phone: '1234567890',
//       username: 'johndoe',
//       password: 'password123',
//       image: null,
//     );

//     final authEntity = AuthEntity(
//       fName: params.fname,
//       lName: params.lname,
//       phone: params.phone,
//       username: params.username,
//       password: params.password,
//       image: params.image,
//     );

//     test('should call registercustomer on the repository with correct entity',
//         () async {
//       when(() => mockAuthRepository.registercustomer(authEntity))
//           .thenAnswer((_) async => Right(null));

//       final result = await registerUseCase(params);

//       expect(result, equals(Right(null)));
//       verify(() => mockAuthRepository.registercustomer(authEntity)).called(1);
//       verifyNoMoreInteractions(mockAuthRepository);
//     });

//     test('should return failure when repository call fails', () async {
//       final failure = ApiFailure(message: 'Registration failed');
//       when(() => mockAuthRepository.registercustomer(authEntity))
//           .thenAnswer((_) async => Left(failure));

//       final result = await registerUseCase(params);

//       expect(result, equals(Left(failure)));
//       verify(() => mockAuthRepository.registercustomer(authEntity)).called(1);
//       verifyNoMoreInteractions(mockAuthRepository);
//     });
//   });
// }
