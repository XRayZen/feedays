// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:feedays/domain/entities/activity.dart';

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
  //URLは””で囲んでおく
  final List<String> searchHistory;
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

class SearchRequest {
  final SearchType searchType;
  final SearchQueryType queryType;
  final String word;
  final String userID;
  final UserIdentInfo identInfo;
  final UserAccountType accountType;
  SearchRequest({
    required this.searchType,
    required this.queryType,
    required this.word,
    required this.userID,
    required this.identInfo,
    required this.accountType,
  });
}

enum SearchQueryType { url, word }

enum SearchType { addContent, powerSearch }

class SearchResult {
  final ApiRequestType apiRequestType;
  //PLAN:AddContentならサイトを返す
  //PowerSearchなら記事を返す
  SearchResult({
    required this.apiRequestType,
  });
}

enum ApiRequestType { refuse, accept }
