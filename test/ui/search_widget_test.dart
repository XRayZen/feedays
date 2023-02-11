import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/main.dart';
import 'package:feedays/ui/page/add_content/web_sites.dart';
import 'package:feedays/ui/page/add_content_page.dart';
import 'package:feedays/ui/page/start_page.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'search_widget_test.mocks.dart';

@GenerateMocks([WebRepositoryInterface, BackendApiRepository])
void main() {
  late WebRepositoryInterface webRepo;
  late BackendApiRepository apiRepo;
  setUp(() {
    webRepo = MockWebRepositoryInterface();
    apiRepo = MockBackendApiRepository();
  });
  testWidgets('Search Widget smoke test', (WidgetTester tester) async {
    //TODO:この機会にモックを使ったWidgetテストをする
    //シナリオ:テキストフィールドにURLを入れたらプロバイダーが回りモックレポジトリで偽のデータが
    //作られUIがそれを指定された数作られた事をテストする
    //立ち上げるのはWebSites
    //まずはプロバイダーをモックに上書きする
    await tester.pumpWidget(
      //ProviderScopeをMaterialAPPで囲まないとエラー
      ProviderScope(
        overrides: [
          //モックレポジトリクラスを上書きDI
          webRepoProvider.overrideWithValue(webRepo),
          backendApiRepoProvider.overrideWithValue(apiRepo)
        ],
        child: const MaterialApp(
          home:
              // AddContentPage(),
              Scaffold(body: WebSites()),
        ),
      ),
    );
    //Widgetテストでのタップ方法を調べる
    //テキストフィールドをタップしてページ遷移したか確認
    expect(find.byKey(const Key('SearchTextFieldTap')), findsOneWidget);
    await tester.tap(find.byKey(const Key('SearchTextFieldTap')));
    await tester.pumpAndSettle(); //描画するまで待つ
    //プロバイダースコープが無いというからいっその事インテグレーションでルートページから辿ってテストするか検討
    expect(find.text('Recent Searches'), findsOneWidget);
    //
  });
}
