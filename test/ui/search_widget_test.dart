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
  testWidgets('SearchFlow Success WidgetTest', (WidgetTester tester) async {
    //モックを使ってサーチフローをUITestで検証する
    //シナリオ:テキストフィールドにURLを入れたらプロバイダーが回りモックレポジトリで
    //偽のデータが作られUIがそれを指定された数作られた事をテストする
    //立ち上げるのはWebSites
    //まずはプロバイダーをモックに上書きする
    
  });
}
