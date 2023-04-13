import 'dart:async';

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/foundation.dart';

abstract class LocalRepositoryInterface {
  Future<void> init();
  Future<void> clear();
  // 変換して上書き保存
  Future<void> saveConfig(UserConfig cfg);
  Future<UserConfig?> readConfig();
  //RSSFeedを保存する
  Future<void> saveFeedData(WebFeedData feeds);
  Future<WebFeedData?> readFeedData();
  Future<void> saveImage(String link, Uint8List data);
  Future<Uint8List?> readImage(String link);
  //端末情報を取得する
  Future<UserAccessIdentInfo> getDevice();
  Future<ByteData> getAssetData(String key);
}
