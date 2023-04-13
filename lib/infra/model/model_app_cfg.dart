// ignore_for_file: public_member_api_docs
import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:hive/hive.dart';

part 'model_app_cfg.g.dart';

@HiveType(typeId: 5)
class ModelAppConfig extends HiveObject {
  ModelAppConfig({
    required this.modelApiRequestConfig,
    required this.modelRssFeedConfig,
    required this.modelUiConfig,
  });
  factory ModelAppConfig.from(AppConfig cfg) {
    return ModelAppConfig(
      modelApiRequestConfig:
          ModelApiRequestLimitConfig.from(cfg.apiRequestConfig),
      modelRssFeedConfig: ModelRssFeedConfig.from(cfg.rssFeedConfig),
      modelUiConfig: ModelUiConfig.from(cfg.uiConfig),
    );
  }
  AppConfig to() {
    return AppConfig(
      apiRequestConfig: modelApiRequestConfig.to(),
      rssFeedConfig: modelRssFeedConfig.to(),
      uiConfig: modelUiConfig.to(),
    );
  }

  @HiveField(0)
  final ModelApiRequestLimitConfig modelApiRequestConfig;
  @HiveField(1)
  final ModelRssFeedConfig modelRssFeedConfig;
  @HiveField(2)
  final ModelUiConfig modelUiConfig;
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
      noneRssFeedRequestLimit: cfg.fetchRssFeedRequestLimit,
      sendActivityMinute: cfg.sendActivityMinute,
    );
  }
  ApiRequestLimitConfig to() {
    return ApiRequestLimitConfig(
      trendRequestLimit: trendRequestLimit,
      fetchRssFeedRequestLimit: noneRssFeedRequestLimit,
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

@HiveType(typeId: 9)
class ModelUiConfig {
  ModelUiConfig({
    required this.themeColorValue,
    required this.themeMode,
    required this.drawerMenuOpacity,
    required this.feedDetailFontSize,
    required this.siteFeedListFontSize,
  });
  factory ModelUiConfig.from(UiConfig cfg) {
    var mode = ModelAppThemeMode.dark;
    switch (cfg.themeMode) {
      case AppThemeMode.light:
        mode = ModelAppThemeMode.light;
        break;
      case AppThemeMode.dark:
        mode = ModelAppThemeMode.dark;
        break;
      case AppThemeMode.system:
        mode = ModelAppThemeMode.system;
        break;
    }
    return ModelUiConfig(
      themeColorValue: cfg.themeColorValue,
      themeMode: mode,
      drawerMenuOpacity: cfg.drawerMenuOpacity,
      feedDetailFontSize: ModelUiResponsiveFontSize(
        mobile: cfg.feedDetailFontSize.mobile,
        tablet: cfg.feedDetailFontSize.tablet,
        defaultSize: cfg.feedDetailFontSize.defaultSize,
      ),
      siteFeedListFontSize: ModelUiResponsiveFontSize(
        mobile: cfg.siteFeedListFontSize.mobile,
        tablet: cfg.siteFeedListFontSize.tablet,
        defaultSize: cfg.siteFeedListFontSize.defaultSize,
      ),
    );
  }
  UiConfig to() {
    var mode = AppThemeMode.dark;
    switch (themeMode) {
      case ModelAppThemeMode.light:
        mode = AppThemeMode.light;
        break;
      case ModelAppThemeMode.dark:
        mode = AppThemeMode.dark;
        break;
      case ModelAppThemeMode.system:
        mode = AppThemeMode.system;
        break;
    }
    return UiConfig(
      themeColorValue: themeColorValue,
      themeMode: mode,
      drawerMenuOpacity: drawerMenuOpacity,
      feedDetailFontSize: UiResponsiveFontSize(
        mobile: feedDetailFontSize.mobile,
        tablet: feedDetailFontSize.tablet,
        defaultSize: feedDetailFontSize.defaultSize,
      ),
      siteFeedListFontSize: UiResponsiveFontSize(
        mobile: siteFeedListFontSize.mobile,
        tablet: siteFeedListFontSize.tablet,
        defaultSize: siteFeedListFontSize.defaultSize,
      ),
    );
  }

  @HiveField(0)
  final int themeColorValue;
  @HiveField(1)
  final ModelAppThemeMode themeMode;
  @HiveField(2)
  final double drawerMenuOpacity;
  @HiveField(3)
  final ModelUiResponsiveFontSize feedDetailFontSize;
  @HiveField(4)
  final ModelUiResponsiveFontSize siteFeedListFontSize;
}

@HiveType(typeId: 10)
enum ModelAppThemeMode {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
  @HiveField(2)
  system,
}

@HiveType(typeId: 11)
class ModelUiResponsiveFontSize {
  ModelUiResponsiveFontSize({
    required this.mobile,
    required this.tablet,
    required this.defaultSize,
  });
  @HiveField(0)
  double mobile;
  @HiveField(1)
  double tablet;
  @HiveField(2)
  double defaultSize;
}
