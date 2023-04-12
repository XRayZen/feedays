// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/material.dart';

import './app_config.dart';

///これはユーザーごとの設定としてサーバーでデータベースに登録され各プラットフォームで同期できる
class UserConfig {
  String userName;
  String password;
  //ユーザーidは初回起動時でサーバーから割り振られるユニークなid
  String userID;
  bool isGuest;
  RssWebSites rssFeedSites;
  AppConfig appConfig;
  UserAccountType accountType;
  List<String> searchHistory;
  List<ExploreCategory> categories;
  UserConfig({
    required this.userName,
    required this.password,
    required this.userID,
    required this.isGuest,
    required this.rssFeedSites,
    required this.appConfig,
    required this.accountType,
    required this.searchHistory,
    required this.categories,
  });

  factory UserConfig.defaultUserConfig() {
    return UserConfig(
      userName: 'userName',
      password: '',
      userID: 'userID',
      isGuest: true,
      rssFeedSites: RssWebSites(folders: []),
      appConfig: AppConfig(
        apiRequestConfig: ApiRequestLimitConfig(
          trendRequestLimit: 10,
          noneRssFeedRequestLimit: 10,
          sendActivityMinute: 10,
        ),
        rssFeedConfig: RssFeedConfig(),
        uiConfig: UiConfig(
          themeColorValue: Colors.amber.value,
          themeMode: AppThemeMode.system,
          feedDetailFontSize: UiResponsiveFontSize(
            mobile: 18,
            tablet: 24,
            defaultSize: 15,
          ),
          siteFeedListFontSize: UiResponsiveFontSize(
            mobile: 11,
            tablet: 15,
            defaultSize: 10,
          ),
          drawerMenuOpacity: 0.5,
        ),
      ),
      accountType: UserAccountType.guest,
      searchHistory: [],
      categories: [],
    );
  }
  void editRecentSearches(String text, {bool isAddOrRemove = true}) {
    if (isAddOrRemove) {
      if (!searchHistory.contains(text)) {
        //PLAN:入力履歴はローカル・クラウド両方に保存しておく
        searchHistory.add(text);
      }
    } else {
      searchHistory.removeWhere((element) => element == text);
    }
  }
}

enum UserAccountType { guest, free, pro, ultimate }

enum ApiResponseType { refuse, accept }
