// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthHiveModelAdapter extends TypeAdapter<AuthHiveModel> {
  @override
  final int typeId = 0;

  @override
  AuthHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthHiveModel(
      userId: fields[0] as String?, // Updated to userId
      name: fields[1] as String, // Mapping directly to name
      email: fields[2] as String, // Mapping to email
      password: fields[3] as String, // Mapping to password
      userImage: fields[4] as String?, // Mapping to userImage
      cPassword: fields[5] as String, // Added mapping for confirm password
    );
  }

  @override
  void write(BinaryWriter writer, AuthHiveModel obj) {
    writer
      ..writeByte(6) // Updated to 6 fields
      ..writeByte(0)
      ..write(obj.userId) // Updated to userId
      ..writeByte(1)
      ..write(obj.name) // Updated to name
      ..writeByte(2)
      ..write(obj.email) // Updated to email
      ..writeByte(3)
      ..write(obj.password) // Updated to password
      ..writeByte(4)
      ..write(obj.userImage) // Updated to userImage
      ..writeByte(5)
      ..write(obj.cPassword); // Added writing for confirm password
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
