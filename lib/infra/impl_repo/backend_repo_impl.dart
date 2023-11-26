// ignore_for_file: flutter_style_todos

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

class ImplBackendApiRepo extends BackendApiRepository {
  @override
  Future<APIResponse> favoriteArticle(
    String userID,
    Article article,
    bool isFavorite,
  ) {
    // TODO: implement favoriteArticle
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> favoriteSite(
    String userID,
    WebSite site,
    bool isFavorite,
  ) {
    // TODO: implement favoriteSite
    throw UnimplementedError();
  }

  @override
  Future<FetchCloudFeedResponse> fetchCloudFeed(String url) {
    // TODO: implement fetchCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<ApiRequestLimitConfig> getApiRequestLimit(
    String userID,
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement getApiRequestLimit
    throw UnimplementedError();
  }

  @override
  Future<List<ExploreCategory>> getExploreCategories(
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement getExploreCategories
    throw UnimplementedError();
  }

  @override
  Future<String> getNewUserID(UserAccessIdentInfo identInfo) {
    // TODO: implement getNewUserID
    throw UnimplementedError();
  }

  @override
  Future<RankingResponse> getRanking(
    String userID,
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement getRanking
    throw UnimplementedError();
  }

  @override
  Future<List<String>> modifySearchHistory(
    String text, {
    bool isAddOrRemove = true,
  }) {
    // TODO: implement modifySearchHistory
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> reportReadActivity(
    ReadActivity activity,
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement reportReadActivity
    throw UnimplementedError();
  }

  @override
  Future<SearchResult> searchWord(ApiSearchRequest request) {
    // TODO: implement searchWord
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> subscribeSite(WebSite site, bool isSubscribe) {
    // TODO: implement subscribeSite
    throw UnimplementedError();
  }

  @override
  Future<UserConfig> syncConfig(String userID, UserAccessIdentInfo identInfo) {
    // TODO: implement syncConfig
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> updateConfig(
    UserConfig cfg,
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement updateConfig
    throw UnimplementedError();
  }

  @override
  Future<APIResponse> userRegister(
    UserConfig cfg,
    UserAccessIdentInfo identInfo,
  ) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }
}
