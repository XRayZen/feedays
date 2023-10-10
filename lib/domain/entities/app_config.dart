// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/ui_config.dart';

class AppConfig {
  final ApiRequestLimitConfig apiRequestConfig;
  final RssFeedConfig rssFeedConfig;
  final UiConfig uiConfig;
  AppConfig({
    required this.apiRequestConfig,
    required this.rssFeedConfig,
    required this.uiConfig,
  });
}

///サーバーから送られるリクエスト間隔制限設定<br/>
///当然だが制限設定はユーザータイプごとに違う
class ApiRequestLimitConfig {
  final int fetchRssFeedRequestInterval;
  final int fetchRssFeedRequestLimit;
  final int trendRequestInterval;
  final int trendRequestLimit;
  ApiRequestLimitConfig({
    required this.fetchRssFeedRequestInterval,
    required this.fetchRssFeedRequestLimit,
    required this.trendRequestInterval,
    required this.trendRequestLimit,
  });
}

class RssFeedConfig {
  ///最終更新日時からどれくらい経ったら更新するか
  int feedRefreshInterval;
  RssFeedConfig({
    this.feedRefreshInterval = 60,
  });
}
