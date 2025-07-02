// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      userId: fields[0] as String?,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      primaryPhone: fields[5] as String,
      secondaryPhone: fields[6] as String?,
      profileImage: fields[8] as String?,
      role: fields[7] as String,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      password: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.primaryPhone)
      ..writeByte(6)
      ..write(obj.secondaryPhone)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.profileImage)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
