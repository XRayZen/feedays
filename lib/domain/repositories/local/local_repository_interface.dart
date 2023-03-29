import 'dart:async';

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

abstract class LocalRepositoryInterface {
  Future<void> init();
  Future<void> clear();
  // 変換して上書き保存
  Future<void> saveConfig(UserConfig cfg);
  Future<UserConfig?> readConfig();
  Future<void> saveImage(String link,Uint8List data);
  Future<Uint8List?> readImage(String link);
  Future<ByteData> getAssetData(String key);
}
