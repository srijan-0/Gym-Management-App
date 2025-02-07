import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/core/error/failure.dart';
import 'package:login/features/auth/domain/repository/auth_repository.dart';
import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Create a mock class for IAuthRepository using mocktail
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UploadImageUsecase uploadImageUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    uploadImageUsecase = UploadImageUsecase(mockAuthRepository);
  });

  group('UploadImageUsecase', () {
    final dummyFile = File('dummy_path');
    const imageUrl = 'http://example.com/image.png';
    final params = UploadImageParams(file: dummyFile);

    test('should return image url when upload is successful', () async {
      when(() => mockAuthRepository.uploadProfilePicture(dummyFile))
          .thenAnswer((_) async => const Right(imageUrl));

      final result = await uploadImageUsecase(params);

      // Assert: Verify that the result is the expected image URL.
      expect(result, equals(const Right(imageUrl)));
      verify(() => mockAuthRepository.uploadProfilePicture(dummyFile))
          .called(1);
    });

    test('should return failure when upload fails', () async {
      final failure = ApiFailure(message: 'Upload failed');
      when(() => mockAuthRepository.uploadProfilePicture(dummyFile))
          .thenAnswer((_) async => Left(failure));

      final result = await uploadImageUsecase(params);

      expect(result, equals(Left(failure)));
      verify(() => mockAuthRepository.uploadProfilePicture(dummyFile))
          .called(1);
    });
  });
}
