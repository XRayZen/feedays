// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/web_sites.dart';

import './app_config.dart';

///これはユーザーごとの設定としてサーバーでデータベースに登録され各プラットフォームで同期できる
class UserConfig {
  String userName;
  String userID; //ユーザーidは初回起動時でサーバーから割り振っれるユニークなid
  bool isGuest;
  RssWebSites rssFeedSites;
  AppConfig config;
  UserIdentInfo identInfo;
  UserAccountType accountType;
  List<String> searchHistory;
  UserConfig({
    required this.userName,
    required this.userID,
    required this.isGuest,
    required this.rssFeedSites,
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
      rssFeedSites: RssWebSites(folders: []),
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
