import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/usecase/api_usecase.dart';
import 'package:feedays/domain/usecase/rss_usecase.dart';
import 'package:feedays/infra/impl_repo/local_repo_impl.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('description', () {
    final webRepo = WebRepoImpl();
    final apiRepo = MockApiRepository();
    final webUse = RssUsecase(
      webRepo: webRepo,
      apiRepo: apiRepo,
      apiUsecase: ApiUsecase(
        backendApiRepo: apiRepo,
        noticeError: (message) async {},
        userCfg: UserConfig.defaultUserConfig(),
        identInfo: UserAccessIdentInfo(
          uUid: 'test',
          accessPlatform: UserAccessPlatform.mobile,
          platformType: UserPlatformType.android,
          brand: 'test',
          deviceName: 'test',
          osVersion: 'test',
          isPhysics: false,
        ),
      ),
      localRepo: LocalRepoImpl(),
      noticeError: (message) async {},
      onAddSite: (site) async {},
      progressCallBack: (count, all, msg) async {},
      rssFeedData: WebFeedData(folders: []),
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
        await webUse.registerRssSite([res.websites.first]);
        //WebUsecaseのサイトに追加されているか期待する
        expect(
          webUse.rssFeedData.anySiteOfURL(path),
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
