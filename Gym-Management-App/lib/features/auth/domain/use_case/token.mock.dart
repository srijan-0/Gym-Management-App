import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login/app/shared_prefs/token_shared_prefs.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    // For saveToken, return a Future<Either<Failure, void>> that is Right(null)
    when(() => mockTokenSharedPrefs.saveToken(any()))
        .thenAnswer((_) async => Right(unit));

    // For getToken, return a Future<Either<Failure, String>> with the sample token
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right('sample_token'));
  });

  test('Should save token and retrieve it successfully', () async {
    const token = 'sample_token';

    // Test the saveToken method:
    final saveResult = await mockTokenSharedPrefs.saveToken(token);
    expect(saveResult, equals(Right(null)));

    // Test the getToken method:
    final retrievedToken = await mockTokenSharedPrefs.getToken();
    expect(retrievedToken, equals(Right(token)));
  });
}
