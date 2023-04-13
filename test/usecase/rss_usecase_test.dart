import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/usecase/api_usecase.dart';
import 'package:feedays/domain/usecase/rss_usecase.dart';
import 'package:feedays/infra/impl_repo/backend_repo_impl.dart';
import 'package:feedays/infra/impl_repo/local_repo_impl.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_local_repo.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:feedays/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('direct URL Parse', () async {
    //サイト記事URLを入力したらそのサイトのRSSURLとサイト名などの各種情報を取得する
    const url = 'https://pioncoo.net/articles/post-386082.html';
    const answerSiteUrl = 'https://pioncoo.net';
    const answerRssUrl = 'https://pioncoo.net/feed';
    const answerSiteName = 'Pioncoo';
    final rssUse = RssUsecase(
      webRepo: WebRepoImpl(),
      apiRepo: BackendApiRepoImpl(),
      localRepo: MockLocalRepo(),
      apiUsecase: ApiUsecase(
        backendApiRepo: BackendApiRepoImpl(),
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
      noticeError: (message) async {},
      onAddSite: (site) async {},
      progressCallBack: (count, all, msg) async {},
      rssFeedData: WebFeedData(folders: []),
      userCfg: UserConfig.defaultUserConfig(),
    );
    final result = await rssUse.searchWord(
      SearchRequest(
        searchType: SearchType.addContent,
        word: url,
      ),
    );
    expect(result.websites, isNotEmpty);
  });
}
