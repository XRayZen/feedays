//TODO:mokitoではスタブを形成できないため手動でモッククラスを作る

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/mock/mock_util.dart';

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
  Future<PreSearchResult> searchWord(ApiSearchRequest request) async {
    //webサイトようも作る
    //TODO:偽データを生成するより実際のサイトのrssファイルを読み込んでテスト
    //NOTE:ここに来る前にビジネスロジックで通常のRSS登録処理が失敗したらサーバーにリクエストしてRSSフィードを取得しようとする

    switch (request.queryType) {
      case SearchQueryType.url:
        //来るのがurlだろうがhtmlの表示テストのためにiphone maniaのサイトを読み込んで返す
        const path = 'https://iphone-mania.jp/feed/';
        final data = await fetchHttpByteData(path);
        final rssItems = await convertXmlToRss(data);
        final fakeSearchResult = PreSearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: 'fake :',
          resultType: SearchResultType.found,
          searchType: request.searchType,
          websites: [],
          articles: rssItems,
        );
        return fakeSearchResult;
      case SearchQueryType.word:
        //サイトは5つの実際のサイトを参考に偽データを生成
        final word = request.word;
        final fakes = await genFakeRssFeeds(10, word);
        final fakeSearchResult = PreSearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: 'fake :{$word}',
          resultType: SearchResultType.found,
          searchType: request.searchType,
          websites: [],
          articles: fakes,
        );
        return fakeSearchResult;
    }
  }

  @override
  Future<bool> userRegister(UserIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }
}

Future<ByteData> getAssetData(String key) async {
  final data = await rootBundle.load(key);
  return data;
}
