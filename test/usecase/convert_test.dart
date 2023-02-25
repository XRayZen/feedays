import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/main.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // アセットを読み込むのに使うrootBundleをテストで使うには、テストプログラムの最初にこれが必要
  // TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'convert to RssFeed',
    () async {
      final webRepo = WebRepoImpl();
      final rssUsecase = RssFeedUsecase(webRepo: webRepo);
      const path = 'http://blog.esuteru.com/index.rdf';
      final res = await rssUsecase.convertFeedLinkToRssItems(path);
      expect(res, isNotEmpty);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
