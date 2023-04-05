import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/infra/model/model_activity.dart';
import 'package:feedays/infra/model/model_app_cfg.dart';
import 'package:feedays/infra/model/model_explore.dart';
import 'package:hive/hive.dart';

part 'model_user_cfg.g.dart';

@HiveType(typeId: 0)
class ModelUserConfig extends HiveObject {
  ModelUserConfig({
    required this.userName,
    required this.password,
    required this.userID,
    required this.isGuest,
    required this.rssFeedSiteFolders,
    required this.config,
    required this.identInfo,
    required this.accountType,
    required this.searchHistory,
    required this.categories,
  });
  factory ModelUserConfig.from(UserConfig e) {
    final obj = List<ModelWebSiteFolder>.empty(growable: true);
    for (final element in e.rssFeedSites.folders) {
      obj.add(ModelWebSiteFolder.from(element));
    }
    return ModelUserConfig(
      userName: e.userName,
      password: e.password,
      userID: e.userID,
      isGuest: e.isGuest,
      rssFeedSiteFolders: obj,
      config: ModelAppConfig.from(e.appConfig),
      identInfo: ModelUserIdentInfo.from(e.identInfo),
      accountType: convertUserAccountType(e.accountType),
      searchHistory: e.searchHistory,
      categories: e.categories.map(ModelExploreCategory.from).toList(),
    );
  }
  UserConfig to() {
    return UserConfig(
      userName: userName,
      password: password,
      userID: userID,
      isGuest: isGuest,
      rssFeedSites: RssWebSites(
        folders: rssFeedSiteFolders.map((e) => e.to()).toList(),
      ),
      appConfig: config.to(),
      identInfo: identInfo.to(),
      accountType: convertModelUserAccountType(accountType),
      searchHistory: searchHistory,
      categories: categories.map((e) => e.to()).toList(),
    );
  }

  @HiveField(0)
  String userName;
  @HiveField(1)
  String userID;
  @HiveField(2)
  bool isGuest;
  @HiveField(3)
  List<ModelWebSiteFolder> rssFeedSiteFolders;
  @HiveField(4)
  ModelAppConfig config;
  @HiveField(5)
  ModelUserIdentInfo identInfo;
  @HiveField(6)
  ModelUserAccountType accountType;
  @HiveField(7)
  List<String> searchHistory;
  @HiveField(8)
  List<ModelExploreCategory> categories;
  @HiveField(9)
  String password;
}

ModelUserAccountType convertUserAccountType(UserAccountType ty) {
  switch (ty) {
    case UserAccountType.guest:
      return ModelUserAccountType.guest;
    case UserAccountType.free:
      return ModelUserAccountType.free;
    case UserAccountType.pro:
      return ModelUserAccountType.pro;
    case UserAccountType.ultimate:
      return ModelUserAccountType.ultimate;
  }
}

UserAccountType convertModelUserAccountType(ModelUserAccountType ty) {
  switch (ty) {
    case ModelUserAccountType.guest:
      return UserAccountType.guest;
    case ModelUserAccountType.free:
      return UserAccountType.free;
    case ModelUserAccountType.pro:
      return UserAccountType.pro;
    case ModelUserAccountType.ultimate:
      return UserAccountType.ultimate;
  }
}

@HiveType(typeId: 7)
enum ModelUserAccountType {
  @HiveField(0)
  guest,
  @HiveField(1)
  free,
  @HiveField(2)
  pro,
  @HiveField(3)
  ultimate
}

@HiveType(typeId: 1)
class ModelWebSiteFolder extends HiveObject {
  ModelWebSiteFolder({
    required this.name,
    required this.children,
  });
  factory ModelWebSiteFolder.from(WebSiteFolder e) {
    return ModelWebSiteFolder(
      name: e.name,
      children: e.children.map(ModelWebSite.from).toList(),
    );
  }
  WebSiteFolder to() {
    return WebSiteFolder(
      name: name,
      children: children.map((e) => e.to()).toList(),
    );
  }

  @HiveField(0)
  String name;
  @HiveField(1)
  List<ModelWebSite> children;
}

@HiveType(typeId: 2)
class ModelWebSite extends HiveObject {
  ModelWebSite({
    this.index = 0,
    required this.keyWebSite,
    required this.name,
    required this.siteUrl,
    required this.siteName,
    this.rssUrl = '',
    required this.iconLink,
    this.newCount = 0,
    this.readLateCount = 0,
    this.category = '',
    required this.tags,
    required this.feeds,
    this.fav = false,
    required this.description,
    this.isCloudFeed = false,
    this.lastModified = 0,
  });
  factory ModelWebSite.from(WebSite e) {
    return ModelWebSite(
      name: e.name,
      index: e.index,
      keyWebSite: e.key,
      siteUrl: e.siteUrl,
      siteName: e.siteName,
      rssUrl: e.rssUrl,
      iconLink: e.iconLink,
      newCount: e.newCount,
      readLateCount: e.readLateCount,
      category: e.category,
      tags: e.tags,
      feeds: e.feeds.map(ModelFeedItem.from).toList(),
      fav: e.fav,
      description: e.description,
      isCloudFeed: e.isCloudFeed,
      lastModified: e.lastModified.millisecondsSinceEpoch,
    );
  }
  WebSite to() {
    return WebSite(
      name: name,
      index: index,
      key: keyWebSite,
      siteUrl: siteUrl,
      siteName: siteName,
      rssUrl: rssUrl,
      iconLink: iconLink,
      newCount: newCount,
      readLateCount: readLateCount,
      category: category,
      tags: tags,
      feeds: feeds.map((e) => e.to()).toList(),
      fav: fav,
      description: description,
      isCloudFeed: isCloudFeed,
      lastModified: DateTime.fromMillisecondsSinceEpoch(lastModified),
    );
  }

  @HiveField(0)
  int index;
  @HiveField(1)
  final String keyWebSite;
  @HiveField(2)
  String name;
  @HiveField(3)
  final String siteUrl;
  @HiveField(4)
  String siteName;
  @HiveField(5)
  String rssUrl;
  @HiveField(7)
  final String iconLink;
  @HiveField(8)
  int newCount;
  @HiveField(9)
  int readLateCount;
  @HiveField(10)
  String category;
  @HiveField(11)
  List<String> tags;
  @HiveField(12)
  List<ModelFeedItem> feeds;
  @HiveField(13)
  bool fav;
  @HiveField(14)
  String description;
  @HiveField(15)
  bool isCloudFeed;
  @HiveField(16)
  int lastModified;
}

@HiveType(typeId: 3)
class ModelFeedItem extends HiveObject {
  ModelFeedItem({
    required this.index,
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.site,
    required this.category,
    required this.lastModified,
    this.isReedLate = false,
  });
  factory ModelFeedItem.from(FeedItem e) {
    return ModelFeedItem(
      index: e.index,
      title: e.title,
      description: e.description,
      link: e.link,
      image: ModelRssFeedImage.from(e.image),
      category: e.category,
      lastModified: e.lastModified,
      isReedLate: e.isReedLate,
      site: e.site,
    );
  }
  FeedItem to() {
    return FeedItem(
      index: index,
      title: title,
      description: description,
      link: link,
      category: category,
      image: image.to(),
      site: site,
      lastModified: lastModified,
      isReedLate: isReedLate,
    );
  }

  @HiveField(0)
  final int index;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String link;
  @HiveField(4)
  ModelRssFeedImage image;
  @HiveField(5)
  final String site;
  @HiveField(6)
  final DateTime lastModified;
  @HiveField(7)
  bool isReedLate;
  @HiveField(8)
  final String category;
}

@HiveType(typeId: 4)
class ModelRssFeedImage extends HiveObject {
  ModelRssFeedImage({
    required this.link,
  });
  factory ModelRssFeedImage.from(RssFeedImage i) {
    return ModelRssFeedImage(
      link: i.link,
    );
  }
  RssFeedImage to() {
    return RssFeedImage(link: link, image: null);
  }

  @HiveField(0)
  final String link;
}
