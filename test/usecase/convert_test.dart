import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/util/convert.dart';
import 'package:feedays/domain/web/http_util.dart';
import 'package:feedays/main.dart';
import 'package:feedays/mock/mock_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // アセットを読み込むのに使うrootBundleをテストで使うには、テストプログラムの最初にこれが必要
  // TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'convert to RssFeed',
    () async {
      const path = 'http://blog.esuteru.com/index.rdf';
      final data = await getHttpByteData(path);
      final res = await convertXmlToRss(data);
      expect(res, isNotEmpty);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
