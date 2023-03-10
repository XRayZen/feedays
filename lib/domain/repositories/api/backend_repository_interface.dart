import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';

abstract class BackendApiRepository {
  Future<bool> login();
  Future<bool> userRegister(UserIdentInfo identInfo);
  ///クラウドフィードサイトの更新を問い合わせる
  Future<WebSite?> requestCloudFeed(String url);
  ///クラウドフィード対応サイトか問い合わせる
  Future<bool> isCompatibleCloudFeed(String url);
  Future<SearchResult> searchWord(ApiSearchRequest request);
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true});
  Future<List<ExploreCategory>> getExploreCategories(UserIdentInfo identInfo);
}
