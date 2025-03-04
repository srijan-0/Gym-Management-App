import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';

import '../../../../../core/common/common_snackbar.dart';
import '../../../domain/use_case/register_user_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseUseCase _registerUseCase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterBloc({
    required RegisterUseUseCase registerUseCase,
    required UploadImageUsecase uploadImageUsecase,
  })  : _registerUseCase = registerUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        super(RegisterState.initial()) {
    on<Registercustomer>(_onRegisterEvent);
    on<UploadImage>(_onLoadImage);
  }

  void _onRegisterEvent(
    Registercustomer event,
    Emitter<RegisterState> emit,
  ) async {
    // Check if fields are empty
    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.cPassword.isEmpty) {
      showMySnackBar(
        context: event.context,
        message: "All fields are required",
      );
      return;
    }

    // Check name length
    if (event.name.length < 3 || event.name.length > 25) {
      showMySnackBar(
        context: event.context,
        message: "Name must be between 3 to 25 characters",
      );
      return;
    }

    // Check password length
    if (event.password.length < 8 || event.password.length > 255) {
      showMySnackBar(
        context: event.context,
        message: "Password must be between 8 to 255 characters",
      );
      return;
    }

    // Check if passwords match
    if (event.password != event.cPassword) {
      showMySnackBar(
        context: event.context,
        message: "Passwords do not match",
      );
      return;
    }

    // Check email validity
    if (!_isValidEmail(event.email)) {
      showMySnackBar(
        context: event.context,
        message: "Invalid email format",
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _registerUseCase.call(RegisterUserParams(
      name: event.name,
      email: event.email,
      password: event.password,
      userImage: event.userImage,
      cPassword: event.cPassword,
    ));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }

  void _onLoadImage(
    UploadImage event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(file: event.file),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true, userImage: r));
      },
    );
  }

  bool _isValidEmail(String email) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}

// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';

// import '../../../domain/use_case/register_user_usecase.dart';

// part 'register_event.dart';
// part 'register_state.dart';

// class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
//   final RegisterUseCase _registerUseCase; // ✅ Fixed Typo
//   final UploadImageUsecase _uploadImageUsecase;

//   RegisterBloc({
//     required RegisterUseCase registerUseCase, // ✅ Fixed Typo
//     required UploadImageUsecase uploadImageUsecase,
//   })  : _registerUseCase = registerUseCase,
//         _uploadImageUsecase = uploadImageUsecase,
//         super(RegisterState.initial()) {
//     on<Registercustomer>(_onRegisterEvent);
//     on<UploadImage>(_onLoadImage);
//   }

//   void _onRegisterEvent(
//     Registercustomer event,
//     Emitter<RegisterState> emit,
//   ) async {
//     // Check if fields are empty
//     if (event.name.isEmpty ||
//         event.email.isEmpty ||
//         event.password.isEmpty ||
//         event.cPassword.isEmpty) {
//       ScaffoldMessenger.of(event.context).showSnackBar(
//         SnackBar(content: Text("All fields are required")),
//       );
//       return;
//     }

//     // Check name length
//     if (event.name.length < 3 || event.name.length > 25) {
//       ScaffoldMessenger.of(event.context).showSnackBar(
//         SnackBar(content: Text("Name must be between 3 to 25 characters")),
//       );
//       return;
//     }

//     // Check password length
//     if (event.password.length < 8 || event.password.length > 255) {
//       ScaffoldMessenger.of(event.context).showSnackBar(
//         SnackBar(content: Text("Password must be between 8 to 255 characters")),
//       );
//       return;
//     }

//     // Check if passwords match
//     if (event.password != event.cPassword) {
//       ScaffoldMessenger.of(event.context).showSnackBar(
//         SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }

//     // Check email validity
//     if (!_isValidEmail(event.email)) {
//       ScaffoldMessenger.of(event.context).showSnackBar(
//         SnackBar(content: Text("Invalid email format")),
//       );
//       return;
//     }

//     emit(state.copyWith(isLoading: true));

//     final result = await _registerUseCase.call(RegisterUserParams(
//       name: event.name,
//       email: event.email,
//       password: event.password,
//       userImage: event.userImage,
//       cPassword: event.cPassword,
//     ));

//     result.fold(
//       (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
//       (r) {
//         emit(state.copyWith(isLoading: false, isSuccess: true));
//         ScaffoldMessenger.of(event.context).showSnackBar(
//           SnackBar(content: Text("Registration Successful")),
//         );
//       },
//     );
//   }

//   void _onLoadImage(
//     UploadImage event,
//     Emitter<RegisterState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true));

//     final result = await _uploadImageUsecase.call(
//       UploadImageParams(file: event.file),
//     );

//     result.fold(
//       (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
//       (r) {
//         emit(state.copyWith(isLoading: false, isSuccess: true, userImage: r));
//       },
//     );
//   }

//   bool _isValidEmail(String email) {
//     final emailRegExp =
//         RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//     return emailRegExp.hasMatch(email);
//   }
// }
