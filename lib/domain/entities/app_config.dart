// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppConfig {
  final ApiRequestLimitConfig apiRequestConfig;
  final RssFeedConfig rssFeedConfig;
  AppConfig({
    required this.apiRequestConfig,
    required this.rssFeedConfig,
  });
}

///サーバーから送られるリクエスト間隔制限設定<br/>
///当然だが制限設定はユーザータイプごとに違う
class ApiRequestLimitConfig {
  final int trendRequestLimit;
  final int noneRssFeedRequestLimit;
  final int sendActivityMinute;
  ApiRequestLimitConfig({
    required this.trendRequestLimit,
    required this.noneRssFeedRequestLimit,
    required this.sendActivityMinute,
  });
}

class RssFeedConfig {
  ///最終更新日時からどれくらい経ったら更新するか
  int limitLastFetchTime;
  RssFeedConfig({
    this.limitLastFetchTime=60,
  });
}
