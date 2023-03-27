import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/infra/model/hive_ctrl.dart';
import 'package:feedays/infra/model/model_user_cfg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalRepoImpl extends LocalRepositoryInterface {
  @override
  Future<ByteData> getAssetData(String key) {
    // TODO: implement getAssetData
    throw UnimplementedError();
  }

  @override
  Future<UserConfig?> read() async {
    final box = await Hive.openBox<ModelUserConfig>('UserCfgBox');
    final model = box.get(1);
    if (model != null) {
      return model.to();
    } else {
      return null;
    }
  }

  @override
  Future<void> save(UserConfig cfg) async {
    //Hiveで保存する
    final box = await Hive.openBox<ModelUserConfig>('UserCfgBox');
    final model = ModelUserConfig.from(cfg);
    if (box.containsKey(1)) {
      //既にあるのなら削除しておく
      await box.delete(1);
    }
    await box.put(1, model);
    await box.flush();
  }

  @override
  Future<void> init() async {
    await initLocalDataHandler();
  }

  @override
  Future<void> clear() async {
    await Hive.deleteBoxFromDisk('UserCfgBox');
    // final box = await Hive.openBox<ModelUserConfig>('UserCfgBox');
    // await box.clear();
    // await box.flush();
  }
}
