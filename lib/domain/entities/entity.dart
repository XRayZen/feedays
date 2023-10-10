// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:flutter/material.dart';

import './app_config.dart';

///これはユーザーごとの設定としてサーバーでデータベースに登録され各プラットフォームで同期できる
class UserConfig {
  String userName;
  //ユーザーidは初回起動時でサーバーから割り振られるユニークなid
  String userUniqueID;
  AppConfig appConfig;
  UserAccountType accountType;
  List<String> searchHistory;
  // ユーザー設定でカテゴリーを保存する意味はあるのか？
  // API実装時に改修する
  List<ExploreCategory> categories;
  // ユーザー設定にサイトの購読情報を入れる
  // API実装時に改修する

  UserConfig({
    required this.userName,
    required this.userUniqueID,
    required this.appConfig,
    required this.accountType,
    required this.searchHistory,
    required this.categories,
  });

  factory UserConfig.defaultUserConfig() {
    return UserConfig(
      userName: 'userName',
      userUniqueID: 'userID',
      appConfig: AppConfig(
        apiRequestConfig: ApiRequestLimitConfig(
          trendRequestLimit: 10,
          fetchRssFeedRequestLimit: 10,
          fetchRssFeedRequestInterval: 10,
          trendRequestInterval: 10,
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
