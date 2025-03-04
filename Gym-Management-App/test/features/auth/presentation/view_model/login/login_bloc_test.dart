import 'package:flutter_test/flutter_test.dart';
import 'package:login/features/auth/domain/use_case/login_usecase.dart';
import 'package:login/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:login/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:login/features/home/presentation/view_model/home_cubit.dart';
import 'package:mocktail/mocktail.dart';

// ✅ Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterBloc extends Mock implements RegisterBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

class FakeBuildContext extends Fake {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterBloc mockRegisterBloc;
  late MockHomeCubit mockHomeCubit;

  setUpAll(() {
    registerFallbackValue(
        LoginParams(email: "test@test.com", password: "password123"));
    registerFallbackValue(FakeBuildContext()); // ✅ Register Fake Context
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterBloc = MockRegisterBloc();
    mockHomeCubit = MockHomeCubit();
// ✅ Use Fake Context

    loginBloc = LoginBloc(
      registerBloc: mockRegisterBloc,
      homeCubit: mockHomeCubit,
      loginUseCase: mockLoginUseCase,
    );
  });

  tearDown(() {
    loginBloc.close();
  });
}
