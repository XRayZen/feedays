// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:feedays/domain/entities/activity.dart';

import './app_config.dart';

///これはユーザーごとの設定としてサーバーでデータベースに登録され各プラットフォームで同期できる
class UserConfig {
  String userName;
  String userID; //ユーザーidは初回起動時でサーバーから割り振っれるユニークなid
  bool isGuest;
  List<WebSite> subscribeSites;
  AppConfig config;
  UserIdentInfo identInfo;
  UserAccountType accountType;
  //URLは””で囲んでおく
  List<String> searchHistory;
  UserConfig({
    required this.userName,
    required this.userID,
    required this.isGuest,
    required this.subscribeSites,
    required this.config,
    required this.identInfo,
    required this.accountType,
    required this.searchHistory,
  });

  factory UserConfig.defaultUserConfig() {
    return UserConfig(
      userName: 'userName',
      userID: 'userID',
      isGuest: true,
      subscribeSites: List.empty(growable: true),
      config: AppConfig(
        apiRequestConfig: ApiRequestLimitConfig(
          trendRequestLimit: 10,
          noneRssFeedRequestLimit: 10,
          sendActivityMinute: 10,
        ),
      ),
      identInfo: UserIdentInfo(
        ip: '0',
        macAddress: 'macAddress',
        token: 'token',
        accessPlatform: UserAccessPlatform.mobile,
      ),
      accountType: UserAccountType.guest,
      searchHistory: [],
    );
  }
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
  factory WebSite.mock(String key, String name, String category) {
    return WebSite(
      key: key,
      name: name,
      url: '',
      newCount: 0,
      readLateCount: 0,
      category: category,
      tags: List.empty(growable: true),
      feeds: List.empty(growable: true),
      fav: false,
    );
  }
}

class RssFeed {
  final int index;
  final String title;
  final String description;
  final String link;
  final ByteData image;
  final String site;

  ///必要ないかも
  final String category;
  RssFeed({
    required this.index,
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.site,
    required this.category,
  });
}

enum UserAccountType { guest, free, pro, ultimate }

enum ApiResponseType { refuse, accept }
