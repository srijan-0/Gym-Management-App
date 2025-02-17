// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String, // Changed to 'name'
      userImage: json['userImage'] as String?, // Changed to 'userImage'
      email: json['email'] as String, // Changed to 'email'
      password: json['password'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name, // Changed to 'name'
      'userImage': instance.userImage, // Changed to 'userImage'
      'email': instance.email, // Changed to 'email'
      'password': instance.password,
    };
