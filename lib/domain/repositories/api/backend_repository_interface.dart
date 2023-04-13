// ignore_for_file: avoid_positional_boolean_parameters

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';

abstract class BackendApiRepository {
  Future<bool> login();
  Future<bool> userRegister(UserConfig cfg,UserAccessIdentInfo identInfo);
  //設定を同期する
  Future<void> syncConfig(UserConfig cfg);
  
  ///クラウドフィードサイトの更新を問い合わせる
  Future<FetchCloudFeedResponse> fetchCloudFeed(String url);
  
  Future<SearchResult> searchWord(ApiSearchRequest request);
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true});
  //サイトを購読・購読解除する
  Future<void> subscribeSite(WebSite site, bool isSubscribe);
  //サイトをお気に入りに登録・解除する
  Future<void> favoriteSite(WebSite site, bool isFavorite);
  //記事をお気に入りに登録・解除する
  Future<void> favoriteArticle(Article article, bool isFavorite);
  Future<List<ExploreCategory>> getExploreCategories(
    UserAccessIdentInfo identInfo,
  );
}
