import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/ui/page/add_content/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import '../mock/mock_repository.dart';
import 'search_widget_test.mocks.dart';

// @GenerateMocks([WebUsecase])
@GenerateNiceMocks([MockSpec<WebRepositoryInterface>()])
void main() {
  late WebRepositoryInterface mockWebRepo;
  late BackendApiRepository mockApiRepo;
  setUp(() {
    //mokitoではなく手動でモッククラスを作るべき
    //ただそうなると動作を臨機応変に変えることは出来なくなる
    mockWebRepo = MockWebRepositoryInterface();
    mockApiRepo = MockApiRepository();
  });
  //TODO:単体テストではうまくいかないので統合テストから動作確認する
  testWidgets('SearchFlow Success WidgetTest', (WidgetTester tester) async {
    //モックを使ってサーチフローをUITestで検証する
    //シナリオ:テキストフィールドにURLを入れたらプロバイダーが回りモックレポジトリで
    //偽のデータが作られUIがそれを指定された数作られた事をテストする
    //立ち上げるのはWebSites
    //まずはプロバイダーをモックに上書きする
    await tester.pumpWidget(
      //ProviderScopeをMaterialAPPで囲まないとエラー
      ProviderScope(
        overrides: [
          //モックレポジトリクラスを上書きDI
          //試しにconfigProviderを上書き
          webRepoProvider.overrideWithValue(mockWebRepo),
          backendApiRepoProvider.overrideWithValue(mockApiRepo)
        ],
        child: const MaterialApp(
          home: Scaffold(body: WebSites()),
        ),
      ),
    );
    //テキストフィールドをタップしてページ遷移したか確認
    expect(find.byKey(const Key('SearchTextFieldTap')), findsOneWidget);
    //WidgetKeyでWidgetを探してタップする
    await tester.tap(find.byKey(const Key('SearchTextFieldTap')));
    //描画するまで待つ
    await tester.pumpAndSettle();
    //プロバイダースコープが無いというからいっその事インテグレーションでルートページから辿ってテストするか検討
    expect(find.text('Recent Searches'), findsOneWidget);
    //NOTE:結局、手動でレポジトリのモッククラスを作ったら解決した
    expect(find.byKey(const Key('SearchTextFormField')), findsOneWidget);
    //SearchTextFormFieldにワードを入れて10件のリストが出てくる
    await tester.enterText(
      find.byKey(const Key('SearchTextFormField')),
      'Test Search Word',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    //BUG:検索結果が表示ならこれは消えているはずだが待っていないからか消えていない
    //NOTE:UIではきえていた
    expect(find.byKey(Key('RecentSearchesText')), findsNothing);
    //BUG:待ってないからかリストビューが見つからない
    //NOTE:UIでは確認出来ているようだが
    expect(find.byKey(const Key('SearchResultListView')), findsOneWidget);
    //
  });
}
