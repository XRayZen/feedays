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
