//mokitoではスタブを形成できないため手動でモッククラスを作る

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_util.dart';


class MockApiRepository extends BackendApiRepository {
  // int ff = 0;//これの変数を次第で動作を変える予定
  @override
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true}) {
    // TODO: implement editRecentSearches
    throw UnimplementedError();
  }

  @override
  Future<bool> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<SearchResult> searchWord(ApiSearchRequest request) async {
    //TODO:#を含んだワードが来たらカテゴリごとの検索として該当カテゴリのサイトリストを返す
    //サイトは5つの実際のサイトを参考に偽データを生成
    final webRepo = WebRepoImpl();
    final rssCase = RssFeedUsecase(webRepo: webRepo);
    final list = genExploreList();
    final word = request.word;
    switch (request.searchType) {
      case SearchType.addContent:
        const path = 'https://iphone-mania.jp/';
        final rssParseRssSite = await webRepo.getFeeds(path);
        final fakeSearchResult = SearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: 'fake :{$word}',
          resultType: SearchResultType.found,
          searchType: request.searchType,
          websites: [rssParseRssSite],
          articles: [],
        );
        return fakeSearchResult;
      case SearchType.exploreWeb:
        //カテゴリを探して返す
        final res = list.where((element) => element.category == word);
        if (res.isNotEmpty) {
          final fakeSearchResult = SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: 'mock category:{$word}',
            resultType: SearchResultType.found,
            searchType: request.searchType,
            websites: res.toList(),
            articles: [],
          );
          return fakeSearchResult;
        }
        return SearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: 'not found',
          resultType: SearchResultType.none,
          searchType: request.searchType,
          websites: [],
          articles: [],
        );
      case SearchType.powerSearch:
        // Power searchはfeed毎に検索する
        return SearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: 'mock category:{$word}',
          resultType: SearchResultType.none,
          searchType: request.searchType,
          websites: [],
          articles: [],
        );
    }
  }

  @override
  Future<bool> userRegister(UserIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

  @override
  Future<bool> isCompatibleCloudFeed(String url) async {
    return false;
  }

  @override
  Future<WebSite?> requestCloudFeed(String url) async {
    // TODO: implement requestCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<List<ExploreCategory>> getExploreCategories(
    UserIdentInfo identInfo,
  ) async {
    //アイコンリンクは初期はイラストやか無料素材を検討
    return [
      ExploreCategory(
        name: 'Game',
        iconLink:
            'https://1.bp.blogspot.com/-APe13dG1QiY/Wm1ypQjCskI/AAAAAAABJ6g/UHHWDomFCeMY7fxzfzYc26TrNwAcT12xACLcBGAs/s800/game_friends_kids_sueoki.png',
      ),
      ExploreCategory(
        name: 'Invest',
        iconLink:
            'https://2.bp.blogspot.com/-W7IykUawA4E/VxC3fw-a9tI/AAAAAAAA58c/OK8HgWv5WvcLgJwPtSBy7lm-BYFGhcmXQCLcB/s800/money_toushi.png',
      ),
      ExploreCategory(
        name: 'Programming',
        iconLink:
            'https://www.pakutaso.com/shared/img/thumb/21830aIMGL99841974_TP_V.jpg',
      ),
      ExploreCategory(
        name: 'News',
        iconLink:
            'https://www.pakutaso.com/shared/img/thumb/roujinIMGL8335_TP_V.jpg',
      ),
    ];
  }
}
