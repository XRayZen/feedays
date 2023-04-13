// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';

class ConfigUsecase {
  final LocalRepositoryInterface localRepo;
  late UserConfig userCfg;
  ConfigUsecase({
    required this.localRepo,
    required this.userCfg,
  });

  Future<void> saveConfig() async {
    await localRepo.saveConfig(userCfg);
  }

  Future<void> clear() async {
    await localRepo.clear();
  }

  //フォントサイズを受け取りフィード詳細ページの設定を更新して永続化する
  Future<void> updateFeedDetailFontSize(
    BuildContext context,
    double size,
  ) async {
    switch (howDeviceType(context)) {
      case DeviceType.mobile:
        userCfg.appConfig.uiConfig.feedDetailFontSize.mobile = size;
        break;
      case DeviceType.tablet:
        userCfg.appConfig.uiConfig.feedDetailFontSize.tablet = size;
        break;
      case DeviceType.pc:
        userCfg.appConfig.uiConfig.feedDetailFontSize.defaultSize = size;
        break;
    }
    await saveConfig();
  }

  //ドロワーメニューの透明度を受け取りドロワーの設定を更新して永続化する
  Future<void> updateDrawerOpacity(
    BuildContext context,
    double opacity,
  ) async {
    userCfg.appConfig.uiConfig.drawerMenuOpacity = opacity;
    await saveConfig();
  }

  bool isDarkMode() {
    return userCfg.appConfig.uiConfig.themeMode == AppThemeMode.dark
        ? true
        : false;
  }

  Future<void> updateDarkMode(BuildContext context, bool isDarkMode) async {
    userCfg.appConfig.uiConfig.themeMode =
        isDarkMode ? AppThemeMode.dark : AppThemeMode.light;
    await saveConfig();
  }
}
