import 'dart:async';

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

abstract class LocalRepositoryInterface {
  Future<void> init();
  Future<void> clear();
  // 変換して上書き保存
  Future<void> save(UserConfig cfg);
  Future<UserConfig?> read();
  Future<ByteData> getAssetData(String key);
}
