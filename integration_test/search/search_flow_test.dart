import 'package:feedays/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// @GenerateNiceMocks([MockSpec<WebRepositoryInterface>()])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Search Flow', () {
    setUp(() {});
    testWidgets('Success SearchFlow', (tester) async {
      //TODO:成功する検索フローを再現して確認する
      await goSearchPage(tester);
      //SearchTextFormFieldにワードを入れて10件のリストが出てくる
      await tester.enterText(
        find.byKey(const Key('SearchTextFormField')),
        'Test Search Word',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('RecentSearchesText')), findsNothing);
      expect(find.byKey(const Key('SearchResultListView')), findsOneWidget);
      
    });
    testWidgets('Failed SearchFlow', (widgetTester) async {
      //失敗するフロー
    });
  });
}

///検索ページまで遷移する
Future<void> goSearchPage(WidgetTester tester) async {
  app.main(isProviderOverRide: true);
  await tester.pumpAndSettle();
  //スタートページからadd_contentページに遷移する
  await tester.tap(find.byTooltip('Add Content'));
  await tester.pumpAndSettle();
  expect(find.text('Add Content'), findsOneWidget);
  await tester.tap(find.byKey(const Key('TabWebSites')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('SearchTextFieldTap')), findsOneWidget);
  await tester.tap(find.byKey(const Key('SearchTextFieldTap')));
  await tester.pumpAndSettle();
  expect(find.text('Recent Searches'), findsOneWidget);
  expect(find.byKey(const Key('SearchTextFormField')), findsOneWidget);
}
