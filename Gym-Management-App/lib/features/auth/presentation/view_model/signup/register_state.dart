part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? userImage;
  final String? error;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.userImage,
    this.error,
  });

  factory RegisterState.initial() => const RegisterState(
        isLoading: false,
        isSuccess: false,
        userImage: null,
        error: null,
      );

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? userImage,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      userImage: userImage ?? this.userImage,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, userImage, error];
}
