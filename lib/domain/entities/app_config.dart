

class AppConfig {
  final ApiRequestLimitConfig apiRequestConfig;
  AppConfig({
    required this.apiRequestConfig,
  });
  
}

///サーバーから送られるリクエスト間隔制限設定<br/>
///当然だが制限設定はユーザータイプごとに違う
///順位入れ替え可能なツリーリストビューのWidgetをflutterコードで教えて
class ApiRequestLimitConfig {}
