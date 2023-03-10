import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/domain/usecase/web_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('description', () {
    final webRepo = WebRepoImpl();
    final apiRepo = MockApiRepository();
    final rssFeedUse = RssFeedUsecase(webRepo: webRepo);
    var webUse = WebUsecase(
      webRepo: webRepo,
      apiRepo: apiRepo,
      rssFeedUsecase: rssFeedUse,
      noticeError: (message) async {},
      onAddSite: (site) async {},
      userCfg: UserConfig.defaultUserConfig(),
    );
    test(
      'Add RssSite',
      () async {
        const path = 'http://blog.esuteru.com/';
        final res = await webUse.searchWord(
          SearchRequest(searchType: SearchType.addContent, word: path),
        );
        //RssLinkとFeedを取得できているのを期待
        expect(res.websites.first.feeds.length, isNonZero);
        //Site registration process
        webUse.registerRssSite(res.websites.first);
        //WebUsecaseのサイトに追加されているか期待する
        expect(
          webUse.userCfg.rssFeedSites.anySiteOfURL(path),
          isTrue,
        );
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
    test('Add word', () async {
      const word = 'フェイクニュース';
      final res = await webUse.searchWord(
        SearchRequest(searchType: SearchType.addContent, word: word),
      );
      //複数のサイトからフィードを取得出来ているのを期待
      //TODO:モックでサイトのフィード10件をむき出して返す
      expect(res.articles.length, isNonZero);
    });
  });
}
