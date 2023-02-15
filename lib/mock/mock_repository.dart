//TODO:mokitoではスタブを形成できないため手動でモッククラスを作る

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

import 'mock_util.dart';

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
    final fakeRssFeeds = genFakeRssFeeds(10);
    final fakeSearchResult = PreSearchResult(
      apiResponse: ApiResponseType.accept,
      responseMessage: 'fake',
      resultType: SearchResultType.found,
      searchType: request.searchType,
      websites: [],
      articles: fakeRssFeeds,
    );
    return fakeSearchResult;
  }

  @override
  Future<bool> userRegister(UserIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }
}
