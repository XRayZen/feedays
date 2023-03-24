//HiveObjectで本当に読み書き出来るのか試す
// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/infra/model/hive_ctrl.dart';
import 'package:feedays/infra/model/model_user_cfg.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  //ファイルIOを伴うテストはPathProviderをモックしないと実行できない
  //https://zenn.dev/laiso/articles/cfff69685553753ee378
  //しかしそうなるとCICDでこのテストは使えるのか疑問

  setUpAll(() async {
    final directory = await Directory.systemTemp.createTemp();
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });
  testWidgets('rw test', (WidgetTester tester) async {
    await tester.runAsync(
      () async {
        //変換するデータを用意する
        final preData = UserConfig.defaultUserConfig();
        //サイトリストを入れる
        final list = genExploreList();
        //RSS取得はここでは出来ない
        preData.rssFeedSites.add(list);
        //データをModelに変換する
        final model = ModelUserConfig.from(preData);
        //Hiveを使い保存する
        await Hive.initFlutter();
        registerAdapter();
        final box = await Hive.openBox<ModelUserConfig>('TestUserCfgBox');
        final key = await box.add(model);
        //実際に保存出来たのか確認する
        final cfg = box.get(key);
        expect(cfg, isNotNull);
      },
    );
  });
}
