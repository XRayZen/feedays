// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_app_cfg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelAppConfigAdapter extends TypeAdapter<ModelAppConfig> {
  @override
  final int typeId = 5;

  @override
  ModelAppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelAppConfig(
      apiRequestConfig: fields[0] as ModelApiRequestLimitConfig,
    );
  }

  @override
  void write(BinaryWriter writer, ModelAppConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.apiRequestConfig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelAppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelApiRequestLimitConfigAdapter
    extends TypeAdapter<ModelApiRequestLimitConfig> {
  @override
  final int typeId = 6;

  @override
  ModelApiRequestLimitConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelApiRequestLimitConfig(
      trendRequestLimit: fields[0] as int,
      noneRssFeedRequestLimit: fields[1] as int,
      sendActivityMinute: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelApiRequestLimitConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.trendRequestLimit)
      ..writeByte(1)
      ..write(obj.noneRssFeedRequestLimit)
      ..writeByte(2)
      ..write(obj.sendActivityMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelApiRequestLimitConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
