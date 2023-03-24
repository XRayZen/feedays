// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_explore.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelExploreCategoryAdapter extends TypeAdapter<ModelExploreCategory> {
  @override
  final int typeId = 25;

  @override
  ModelExploreCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelExploreCategory(
      name: fields[0] as String,
      iconLink: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelExploreCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.iconLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelExploreCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
