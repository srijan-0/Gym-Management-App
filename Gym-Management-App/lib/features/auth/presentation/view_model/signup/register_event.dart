part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class UploadImage extends RegisterEvent {
  final File file;

  const UploadImage({
    required this.file,
  });
}

class Registercustomer extends RegisterEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String password;
  final String cPassword; // Added confirmPassword field
  final String? userImage;

  const Registercustomer({
    required this.context,
    required this.name,
    required this.email,
    required this.password,
    required this.cPassword, // Include confirmPassword in constructor
    this.userImage,
  });

  @override
  List<Object> get props =>
      [context, name, email, password, cPassword, userImage ?? ''];
}
