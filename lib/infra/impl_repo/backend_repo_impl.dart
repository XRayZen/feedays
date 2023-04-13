import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

class BackendApiRepoImpl extends BackendApiRepository {
  @override
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true}) {
    // TODO: implement editRecentSearches
    throw UnimplementedError();
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
  Future<FetchCloudFeedResponse> fetchCloudFeed(String url) {
    // TODO: implement fetchCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<List<ExploreCategory>> getExploreCategories(UserAccessIdentInfo identInfo) {
    // TODO: implement getExploreCategories
    throw UnimplementedError();
  }

  @override
  Future<bool> isCompatibleCloudFeed(String url) {
    // TODO: implement isCompatibleCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<bool> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<SearchResult> searchWord(ApiSearchRequest request) {
    // TODO: implement searchWord
    throw UnimplementedError();
  }

  @override
  Future<void> subscribeSite(WebSite site, bool isSubscribe) {
    // TODO: implement subscribeSite
    throw UnimplementedError();
  }



  @override
  Future<void> syncConfig(UserConfig cfg) {
    // TODO: implement syncConfig
    throw UnimplementedError();
  }
  
  @override
  Future<bool> userRegister(UserConfig cfg, UserAccessIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

}
