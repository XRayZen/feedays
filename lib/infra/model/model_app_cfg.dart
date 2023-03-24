import 'package:feedays/domain/entities/app_config.dart';
import 'package:hive/hive.dart';

part 'model_app_cfg.g.dart';

@HiveType(typeId: 5)
class ModelAppConfig extends HiveObject {
  ModelAppConfig({
    required this.apiRequestConfig,
  });
  factory ModelAppConfig.from(AppConfig cfg) {
    return ModelAppConfig(
      apiRequestConfig: ModelApiRequestLimitConfig.from(cfg.apiRequestConfig),
    );
  }
  AppConfig to() {
    return AppConfig(apiRequestConfig: apiRequestConfig.to());
  }

  @HiveField(0)
  final ModelApiRequestLimitConfig apiRequestConfig;
}

///サーバーから送られるリクエスト間隔制限設定<br/>
///当然だが制限設定はユーザータイプごとに違う
@HiveType(typeId: 6)
class ModelApiRequestLimitConfig extends HiveObject {
  ModelApiRequestLimitConfig({
    required this.trendRequestLimit,
    required this.noneRssFeedRequestLimit,
    required this.sendActivityMinute,
  });
  factory ModelApiRequestLimitConfig.from(ApiRequestLimitConfig cfg) {
    return ModelApiRequestLimitConfig(
      trendRequestLimit: cfg.trendRequestLimit,
      noneRssFeedRequestLimit: cfg.noneRssFeedRequestLimit,
      sendActivityMinute: cfg.sendActivityMinute,
    );
  }
  ApiRequestLimitConfig to() {
    return ApiRequestLimitConfig(
      trendRequestLimit: trendRequestLimit,
      noneRssFeedRequestLimit: noneRssFeedRequestLimit,
      sendActivityMinute: sendActivityMinute,
    );
  }

  @HiveField(0)
  final int trendRequestLimit;
  @HiveField(1)
  final int noneRssFeedRequestLimit;
  @HiveField(2)
  final int sendActivityMinute;
}
