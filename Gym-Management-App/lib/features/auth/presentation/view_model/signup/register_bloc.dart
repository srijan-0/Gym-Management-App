import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:login/features/auth/domain/use_case/upload_image_usecase.dart';

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
    on<LoadCoursesAndBatches>(_onLoadCoursesAndBatches);
  }

  void _onRegisterEvent(
    Registercustomer event,
    Emitter<RegisterState> emit,
  ) async {
    print("Register Event Started: ${event.email}");

    // Validation checks
    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.cPassword.isEmpty) {
      emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: "All fields are required"));
      print("Validation Failed: All fields are required");
      return;
    }

    if (event.name.length < 3 || event.name.length > 25) {
      emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: "Name must be between 3 to 25 characters"));
      print("Validation Failed: Invalid name length");
      return;
    }

    if (event.password.length < 8 || event.password.length > 255) {
      emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: "Password must be between 8 to 255 characters"));
      print("Validation Failed: Invalid password length");
      return;
    }

    if (event.password != event.cPassword) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: "Passwords do not match"));
      print("Validation Failed: Passwords do not match");
      return;
    }

    if (!_isValidEmail(event.email)) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: "Invalid email format"));
      print("Validation Failed: Invalid email format");
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    print("State: isLoading: true");

    try {
      final result = await _registerUseCase.call(RegisterUserParams(
        name: event.name,
        email: event.email,
        password: event.password,
        userImage: event.userImage,
        cPassword: event.cPassword,
      ));

      result.fold(
        (l) {
          emit(state.copyWith(
              isLoading: false,
              isSuccess: false,
              error: "Registration Success"));
        },
        (r) {
          print("API Response: $r");
          emit(state.copyWith(isLoading: false, isSuccess: true, error: null));
          print("State: isLoading: false, isSuccess: true");
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isSuccess: false, error: "Unexpected error: $e"));
      print("Unexpected Error: $e");
    }
  }

  void _onLoadImage(
    UploadImage event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    print("Image Upload Started");

    final result = await _uploadImageUsecase.call(
      UploadImageParams(file: event.file),
    );

    result.fold(
      (l) {
        emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: "Image upload failed: $l"));
        print("Image Upload Failed: $l");
      },
      (r) {
        emit(state.copyWith(
            isLoading: false, isSuccess: true, userImage: r, error: null));
        print("Image Upload Success: $r");
      },
    );
  }

  void _onLoadCoursesAndBatches(
    LoadCoursesAndBatches event,
    Emitter<RegisterState> emit,
  ) async {
    print("LoadCoursesAndBatches event triggered");
  }

  bool _isValidEmail(String email) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}
