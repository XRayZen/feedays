import 'dart:async';

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

abstract class LocalRepositoryInterface {
  // 変換して保存
  Future<void> save(UserConfig cfg);

  Future<UserConfig> read();
  Future<ByteData> getAssetData(String key);
}
