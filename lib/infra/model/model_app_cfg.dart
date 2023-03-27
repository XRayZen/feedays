// ignore_for_file: public_member_api_docs
import 'package:feedays/domain/entities/app_config.dart';
import 'package:hive/hive.dart';

part 'model_app_cfg.g.dart';

@HiveType(typeId: 5)
class ModelAppConfig extends HiveObject {
  ModelAppConfig({
    required this.modelApiRequestConfig,
    required this.modelRssFeedConfig,
  });
  factory ModelAppConfig.from(AppConfig cfg) {
    return ModelAppConfig(
      modelApiRequestConfig:
          ModelApiRequestLimitConfig.from(cfg.apiRequestConfig),
      modelRssFeedConfig: ModelRssFeedConfig.from(cfg.rssFeedConfig),
    );
  }
  AppConfig to() {
    return AppConfig(
      apiRequestConfig: modelApiRequestConfig.to(),
      rssFeedConfig: modelRssFeedConfig.to(),
    );
  }

  @HiveField(0)
  final ModelApiRequestLimitConfig modelApiRequestConfig;
  @HiveField(1)
  final ModelRssFeedConfig modelRssFeedConfig;
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

@HiveType(typeId: 8)
class ModelRssFeedConfig extends HiveObject {
  ModelRssFeedConfig({
    required this.limitLastFetchTime,
  });
  factory ModelRssFeedConfig.from(RssFeedConfig cfg) {
    return ModelRssFeedConfig(limitLastFetchTime: cfg.limitLastFetchTime);
  }
  @HiveField(0)
  int limitLastFetchTime;
  RssFeedConfig to() {
    return RssFeedConfig(limitLastFetchTime: limitLastFetchTime);
  }
}
