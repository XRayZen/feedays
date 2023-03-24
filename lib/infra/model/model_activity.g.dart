// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUserReadActivityAdapter extends TypeAdapter<ModelUserReadActivity> {
  @override
  final int typeId = 22;

  @override
  ModelUserReadActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserReadActivity(
      userID: fields[0] as String,
      title: fields[1] as String,
      link: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserReadActivity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserReadActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUserSubscribeActivityAdapter
    extends TypeAdapter<ModelUserSubscribeActivity> {
  @override
  final int typeId = 21;

  @override
  ModelUserSubscribeActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserSubscribeActivity(
      userID: fields[0] as String,
      ip: fields[1] as String,
      title: fields[2] as String,
      link: fields[3] as String,
      category: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserSubscribeActivity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.ip)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.link)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserSubscribeActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUserIdentInfoAdapter extends TypeAdapter<ModelUserIdentInfo> {
  @override
  final int typeId = 20;

  @override
  ModelUserIdentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserIdentInfo(
      ip: fields[0] as String,
      macAddress: fields[1] as String,
      uUid: fields[2] as String?,
      token: fields[3] as String,
      accessPlatform: fields[4] as ModelUserAccessPlatform,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserIdentInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.macAddress)
      ..writeByte(2)
      ..write(obj.uUid)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.accessPlatform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserIdentInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUserAccessPlatformAdapter
    extends TypeAdapter<ModelUserAccessPlatform> {
  @override
  final int typeId = 23;

  @override
  ModelUserAccessPlatform read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModelUserAccessPlatform.pc;
      case 1:
        return ModelUserAccessPlatform.web;
      case 2:
        return ModelUserAccessPlatform.mobile;
      case 3:
        return ModelUserAccessPlatform.tablet;
      default:
        return ModelUserAccessPlatform.pc;
    }
  }

  @override
  void write(BinaryWriter writer, ModelUserAccessPlatform obj) {
    switch (obj) {
      case ModelUserAccessPlatform.pc:
        writer.writeByte(0);
        break;
      case ModelUserAccessPlatform.web:
        writer.writeByte(1);
        break;
      case ModelUserAccessPlatform.mobile:
        writer.writeByte(2);
        break;
      case ModelUserAccessPlatform.tablet:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserAccessPlatformAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
