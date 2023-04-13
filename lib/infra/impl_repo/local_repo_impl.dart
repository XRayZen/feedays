// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:typed_data';

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/infra/model/hive_ctrl.dart';
import 'package:feedays/infra/model/model_user_cfg.dart';
import 'package:feedays/util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalRepoImpl extends LocalRepositoryInterface {
  @override
  Future<ByteData> getAssetData(String key) {
    // TODO: implement getAssetData
    throw UnimplementedError();
  }

  @override
  Future<UserConfig?> readConfig() async {
    try {
      final box = await Hive.openBox<ModelUserConfig>('UserCfgBox');
      final model = box.get(1);
      if (model != null) {
        return model.to();
      } else {
        await clear();
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveConfig(UserConfig cfg) async {
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
    await Hive.deleteBoxFromDisk('WebImageBox');
  }

  @override
  Future<Uint8List?> readImage(String link) async {
    final box = await Hive.openBox<Uint8List>('WebImageBox');
    return box.get(link);
  }

  @override
  Future<void> saveImage(String link, Uint8List data) async {
    final box = await Hive.openBox<Uint8List>('WebImageBox');
    await box.put(link, data);
    await box.flush();
  }

  @override
  Future<UserAccessIdentInfo> getDevice() async {
    //端末情報を取得する
    final deviceData = await detectDeviceInfo();
    bool isPhysics = false;
    if (deviceData['isPhysicalDevice'] != null) {
      isPhysics = deviceData['isPhysicalDevice'] == true;
    }
    return UserAccessIdentInfo(
      uUid: deviceData['UUID']?.toString() ?? 'None',
      brand: deviceData['brand']?.toString() ?? '',
      platformType: detectPlatformType(),
      accessPlatform: detectAccessPlatformType(),
      deviceName: deviceData['device']?.toString() ?? '',
      osVersion: deviceData['OS.Version'].toString(),
      isPhysics: isPhysics,
    );
  }
}
