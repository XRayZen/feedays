//mokitoではスタブを形成できないため手動でモッククラスを作る

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_util.dart';

class MockApiRepository extends BackendApiRepository {
  // int ff = 0;//これの変数を次第で動作を変える予定

  @override
  Future<List<ExploreCategory>> getExploreCategories(
    UserAccessIdentInfo identInfo,
  ){

  }

  @override
  Future<void> modifySearchHistory(String text, {bool isAddOrRemove = true}) {
    // TODO: implement editRecentSearches
    throw UnimplementedError();
  }


  @override
  Future<SearchResult> searchWord(ApiSearchRequest request) async {
    //#を含んだワードが来たらカテゴリごとの検索として該当カテゴリのサイトリストを返す
    //サイトは5つの実際のサイトを参考に偽データを生成
    final webRepo = WebRepoImpl();
    final list = genExploreList();
    final word = request.word;
    switch (request.searchType) {
      case SearchType.url:
        //検索分が空ならnot foundを返す
        if (word == '') {
          return SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: 'not found',
            resultType: SearchResultType.none,
            searchType: request.searchType,
            websites: [],
            articles: [],
          );
        }
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
      case SearchType.keyword:
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
  Future<bool> isCompatibleCloudFeed(String url) async {
    return false;
  }

  @override
  Future<List<ExploreCategory>> getExploreCategories(
    UserAccessIdentInfo identInfo,
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

  @override
  Future<void> favoriteArticle(Article article, bool isFavorite) {
    // TODO: implement favoriteArticle
    throw UnimplementedError();
  }

  @override
  Future<void> favoriteSite(WebSite site, bool isFavorite) {
    // TODO: implement favoriteSite
    throw UnimplementedError();
  }

  @override
  Future<void> subscribeSite(WebSite site, bool isSubscribe) {
    // TODO: implement subscribeSite
    throw UnimplementedError();
  }

  @override
  Future<void> updateConfig(UserConfig cfg) {
    // TODO: implement syncConfig
    throw UnimplementedError();
  }

  @override
  Future<FetchCloudFeedResponse> fetchCloudFeed(String url) {
    // TODO: implement fetchCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<bool> userRegister(UserConfig cfg, UserAccessIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

  @override
  Future<ConfigSyncResponse> codeSync(
      String code, UserAccessIdentInfo identInfo) {
    // TODO: implement codeSync
    throw UnimplementedError();
  }

  @override
  Future<void> reportReadActivity() {
    // TODO: implement reportActivity
    throw UnimplementedError();
  }
}
