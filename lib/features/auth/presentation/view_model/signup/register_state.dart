part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? userImage; // Updated to userImage

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.userImage, // Using userImage instead of imageName
  });

  const RegisterState.initial()
      : isLoading = false,
        isSuccess = false,
        userImage = null; // Initialize userImage as null

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? userImage, // Renamed parameter to match userImage
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      userImage: userImage ?? this.userImage, // Updated to userImage
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSuccess, userImage]; // Updated to userImage
}
