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
      modelApiRequestConfig: fields[0] as ModelApiRequestLimitConfig,
      modelRssFeedConfig: fields[1] as ModelRssFeedConfig,
      modelUiConfig: fields[2] as ModelUiConfig,
    );
  }

  @override
  void write(BinaryWriter writer, ModelAppConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.modelApiRequestConfig)
      ..writeByte(1)
      ..write(obj.modelRssFeedConfig)
      ..writeByte(2)
      ..write(obj.modelUiConfig);
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
      trendRequestInterval: fields[1] as int,
      fetchRssFeedRequestInterval: fields[2] as int,
      fetchRssFeedRequestLimit: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelApiRequestLimitConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.trendRequestLimit)
      ..writeByte(1)
      ..write(obj.trendRequestInterval)
      ..writeByte(2)
      ..write(obj.fetchRssFeedRequestInterval)
      ..writeByte(3)
      ..write(obj.fetchRssFeedRequestLimit);
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

class ModelRssFeedConfigAdapter extends TypeAdapter<ModelRssFeedConfig> {
  @override
  final int typeId = 8;

  @override
  ModelRssFeedConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelRssFeedConfig(
      limitLastFetchTime: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelRssFeedConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.limitLastFetchTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelRssFeedConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUiConfigAdapter extends TypeAdapter<ModelUiConfig> {
  @override
  final int typeId = 9;

  @override
  ModelUiConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUiConfig(
      themeColorValue: fields[0] as int,
      themeMode: fields[1] as ModelAppThemeMode,
      drawerMenuOpacity: fields[2] as double,
      feedDetailFontSize: fields[3] as ModelUiResponsiveFontSize,
      siteFeedListFontSize: fields[4] as ModelUiResponsiveFontSize,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUiConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.themeColorValue)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.drawerMenuOpacity)
      ..writeByte(3)
      ..write(obj.feedDetailFontSize)
      ..writeByte(4)
      ..write(obj.siteFeedListFontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUiConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUiResponsiveFontSizeAdapter
    extends TypeAdapter<ModelUiResponsiveFontSize> {
  @override
  final int typeId = 11;

  @override
  ModelUiResponsiveFontSize read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUiResponsiveFontSize(
      mobile: fields[0] as double,
      tablet: fields[1] as double,
      defaultSize: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ModelUiResponsiveFontSize obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mobile)
      ..writeByte(1)
      ..write(obj.tablet)
      ..writeByte(2)
      ..write(obj.defaultSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUiResponsiveFontSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelAppThemeModeAdapter extends TypeAdapter<ModelAppThemeMode> {
  @override
  final int typeId = 10;

  @override
  ModelAppThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModelAppThemeMode.light;
      case 1:
        return ModelAppThemeMode.dark;
      case 2:
        return ModelAppThemeMode.system;
      default:
        return ModelAppThemeMode.light;
    }
  }

  @override
  void write(BinaryWriter writer, ModelAppThemeMode obj) {
    switch (obj) {
      case ModelAppThemeMode.light:
        writer.writeByte(0);
        break;
      case ModelAppThemeMode.dark:
        writer.writeByte(1);
        break;
      case ModelAppThemeMode.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelAppThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
