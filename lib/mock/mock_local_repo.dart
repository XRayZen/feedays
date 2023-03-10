import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:flutter/services.dart';

class MockLocalRepo extends LocalRepositoryInterface {
  @override
  Future<UserConfig> read() async {
    //モックテストパターンとして通常なサイトを登録済みとして返す
    var cfg = UserConfig.defaultUserConfig();
    cfg.rssFeedSites.add(await genValidSite());
    return cfg;
  }

  @override
  Future<void> save(UserConfig cfg) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<ByteData> getAssetData(String key) async {
    final data = await rootBundle.load(key);
    return data;
  }
}
