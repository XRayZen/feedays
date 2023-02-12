import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:feedays/main.dart' as app;
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Search Flow', () {
    testWidgets('Success SearchFlow', (widgetTester) async {
      //TODO:成功する検索フローを再現して確認する
    });
    testWidgets('Failed SearchFlow', (widgetTester)async {
      //失敗するフロー
      
    });
  });
}
