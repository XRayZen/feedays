import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:feedays/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ogpImage', () async {
    const path = 'http://jin115.com/archives/52365485.html';
    final webrepo = WebRepoImpl();
    final response = await webrepo.fetchHttpString(path, isUtf8: true);
    final data = await webrepo.getOGPImageUrl(path);
    expect(data, isNotNull);
  });
  test(
    'Repo->getRssFeedInWebSite',
    () async {
      //インフラ層ではRepo->サイトURLでメタ・RSSを取得変換して例外有りで返す
      const path = 'http://jin115.com/archives/52365485.html';
      final webrepo = WebRepoImpl();
      final response = await webrepo.getFeeds(path);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
    test(
    'Get WebSite',
    () async {
      //4GamerのサイトをメタとRSSFeedを含んだ完全なWebSiteを取得する
      final webRepo = WebRepoImpl();
      final list = genExploreList();
      for (final element in list) {
        final res = await webRepo.getFeeds(
          element.siteUrl,
          progressCallBack: showDownloadProgress,
        );
        //取得フローが複雑過ぎたのでリファクタリングする
        expect(res.feeds, isNotEmpty);
      }
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
