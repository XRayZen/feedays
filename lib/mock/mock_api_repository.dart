//TODO:mokitoではスタブを形成できないため手動でモッククラスを作る

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter/services.dart';

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
    //サイトは5つの実際のサイトを参考に偽データを生成
    var webRepo = WebRepoImpl();
    var rsscase = RssFeedUsecase(webRepo: webRepo);
    final word = request.word;
    final path = 'https://iphone-mania.jp/';
    final resParseRssSite = await rsscase.parseRss(path);
    final fakeSearchResult = SearchResult(
      apiResponse: ApiResponseType.accept,
      responseMessage: 'fake :{$word}',
      resultType: SearchResultType.found,
      searchType: request.searchType,
      websites: [resParseRssSite!],
      articles: [],
    );
    return fakeSearchResult;
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
}

Future<ByteData> getAssetData(String key) async {
  final data = await rootBundle.load(key);
  return data;
}
