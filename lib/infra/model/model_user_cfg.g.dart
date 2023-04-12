// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user_cfg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelUserConfigAdapter extends TypeAdapter<ModelUserConfig> {
  @override
  final int typeId = 0;

  @override
  ModelUserConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelUserConfig(
      userName: fields[0] as String,
      password: fields[9] as String,
      userID: fields[1] as String,
      isGuest: fields[2] as bool,
      rssFeedSiteFolders: (fields[3] as List).cast<ModelWebSiteFolder>(),
      config: fields[4] as ModelAppConfig,
      accountType: fields[6] as ModelUserAccountType,
      searchHistory: (fields[7] as List).cast<String>(),
      categories: (fields[8] as List).cast<ModelExploreCategory>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelUserConfig obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.isGuest)
      ..writeByte(3)
      ..write(obj.rssFeedSiteFolders)
      ..writeByte(4)
      ..write(obj.config)
      ..writeByte(6)
      ..write(obj.accountType)
      ..writeByte(7)
      ..write(obj.searchHistory)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelWebSiteFolderAdapter extends TypeAdapter<ModelWebSiteFolder> {
  @override
  final int typeId = 1;

  @override
  ModelWebSiteFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelWebSiteFolder(
      name: fields[0] as String,
      children: (fields[1] as List).cast<ModelWebSite>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelWebSiteFolder obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelWebSiteFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelWebSiteAdapter extends TypeAdapter<ModelWebSite> {
  @override
  final int typeId = 2;

  @override
  ModelWebSite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelWebSite(
      index: fields[0] as int,
      keyWebSite: fields[1] as String,
      name: fields[2] as String,
      siteUrl: fields[3] as String,
      siteName: fields[4] as String,
      rssUrl: fields[5] as String,
      iconLink: fields[7] as String,
      newCount: fields[8] as int,
      readLateCount: fields[9] as int,
      category: fields[10] as String,
      tags: (fields[11] as List).cast<String>(),
      feeds: (fields[12] as List).cast<ModelFeedItem>(),
      fav: fields[13] as bool,
      description: fields[14] as String,
      isCloudFeed: fields[15] as bool,
      lastModified: fields[16] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelWebSite obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.keyWebSite)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.siteUrl)
      ..writeByte(4)
      ..write(obj.siteName)
      ..writeByte(5)
      ..write(obj.rssUrl)
      ..writeByte(7)
      ..write(obj.iconLink)
      ..writeByte(8)
      ..write(obj.newCount)
      ..writeByte(9)
      ..write(obj.readLateCount)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.feeds)
      ..writeByte(13)
      ..write(obj.fav)
      ..writeByte(14)
      ..write(obj.description)
      ..writeByte(15)
      ..write(obj.isCloudFeed)
      ..writeByte(16)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelWebSiteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelFeedItemAdapter extends TypeAdapter<ModelFeedItem> {
  @override
  final int typeId = 3;

  @override
  ModelFeedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelFeedItem(
      index: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      link: fields[3] as String,
      image: fields[4] as ModelRssFeedImage,
      site: fields[5] as String,
      category: fields[8] as String,
      lastModified: fields[6] as DateTime,
      isReedLate: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ModelFeedItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.link)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.site)
      ..writeByte(6)
      ..write(obj.lastModified)
      ..writeByte(7)
      ..write(obj.isReedLate)
      ..writeByte(8)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelFeedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelRssFeedImageAdapter extends TypeAdapter<ModelRssFeedImage> {
  @override
  final int typeId = 4;

  @override
  ModelRssFeedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelRssFeedImage(
      link: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelRssFeedImage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelRssFeedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelUserAccountTypeAdapter extends TypeAdapter<ModelUserAccountType> {
  @override
  final int typeId = 7;

  @override
  ModelUserAccountType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModelUserAccountType.guest;
      case 1:
        return ModelUserAccountType.free;
      case 2:
        return ModelUserAccountType.pro;
      case 3:
        return ModelUserAccountType.ultimate;
      default:
        return ModelUserAccountType.guest;
    }
  }

  @override
  void write(BinaryWriter writer, ModelUserAccountType obj) {
    switch (obj) {
      case ModelUserAccountType.guest:
        writer.writeByte(0);
        break;
      case ModelUserAccountType.free:
        writer.writeByte(1);
        break;
      case ModelUserAccountType.pro:
        writer.writeByte(2);
        break;
      case ModelUserAccountType.ultimate:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelUserAccountTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
