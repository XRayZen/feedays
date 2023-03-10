import 'dart:async';

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

abstract class LocalRepositoryInterface {
  // SharedPreferencesなどに保存
  Future<void> save(UserConfig cfg);

  Future<UserConfig> read();
  Future<ByteData> getAssetData(String key);
}
