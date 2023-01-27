// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/activity.dart';
import 'package:flutter/foundation.dart';

import './app_config.dart';

///これはユーザーごとの設定としてサーバーでデータベースに登録され各プラットフォームで同期できる
class UserConfig {
  final String userName;
  final String userID; //ユーザーidは初回起動時でサーバーから割り振っれるユニークなid
  final bool isGuest;
  final List<WebSite> subscribeSites;
  final AppConfig config;
  final UserIdentInfo identInfo;
  final UserAccountType accountType;
  UserConfig(
      {required this.userName,
      required this.userID,
      required this.isGuest,
      required this.subscribeSites,
      required this.config,
      required this.identInfo,
      required this.accountType
      });
}

class WebSite {
  final String key;
  final String name;
  final String url;
  final ByteData? icon;
  final int newCount;
  final int readLateCount;
  final String category;
  final List<String> tags;
  final List<RssFeed> feeds;
  final bool fav;
  WebSite({
    required this.key,
    required this.name,
    required this.url,
    this.icon,
    required this.newCount,
    required this.readLateCount,
    required this.category,
    required this.tags,
    required this.feeds,
    required this.fav,
  });
}

class RssFeed {
  final String title;
  final String description;
  final String link;
  final ByteData image;
  RssFeed({
    required this.title,
    required this.description,
    required this.link,
    required this.image,
  });
}

enum UserAccountType { guest, free, pro, ultimate }
