// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppConfig {
  final ApiRequestLimitConfig apiRequestConfig;
  AppConfig({
    required this.apiRequestConfig,
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
