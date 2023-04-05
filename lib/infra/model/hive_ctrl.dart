//Hive関連のコードを記述する

// ignore_for_file: cascade_invocations

import 'package:feedays/infra/model/model_activity.dart';
import 'package:feedays/infra/model/model_app_cfg.dart';
import 'package:feedays/infra/model/model_explore.dart';
import 'package:feedays/infra/model/model_user_cfg.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initLocalDataHandler() async {
  await Hive.initFlutter();
  registerAdapter();
}

void registerAdapter() {
  //使うクラスのアダプターを全て登録しとく必要がある
  //model_user_cfg
  Hive.registerAdapter(ModelUserConfigAdapter());
  Hive.registerAdapter(ModelWebSiteFolderAdapter());
  Hive.registerAdapter(ModelWebSiteAdapter());
  Hive.registerAdapter(ModelFeedItemAdapter());
  Hive.registerAdapter(ModelRssFeedImageAdapter());
  Hive.registerAdapter(ModelUserAccountTypeAdapter());
  //model_explore
  Hive.registerAdapter(ModelExploreCategoryAdapter());
  //model_app_cfg
  Hive.registerAdapter(ModelAppConfigAdapter());
  Hive.registerAdapter(ModelApiRequestLimitConfigAdapter());
  Hive.registerAdapter(ModelRssFeedConfigAdapter());
  Hive.registerAdapter(ModelUiConfigAdapter());
  Hive.registerAdapter(ModelUiResponsiveFontSizeAdapter());
  Hive.registerAdapter(ModelAppThemeModeAdapter());
  //model_activity
  Hive.registerAdapter(ModelUserReadActivityAdapter());
  Hive.registerAdapter(ModelUserSubscribeActivityAdapter());
  Hive.registerAdapter(ModelUserIdentInfoAdapter());
  Hive.registerAdapter(ModelUserAccessPlatformAdapter());
}
