import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

class BackendApiRepoImpl extends BackendApiRepository {
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
  Future<bool> userRegister(UserIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

  @override
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true}) {
    // TODO: implement editRecentSearches
    throw UnimplementedError();
  }

  @override
  Future<bool> isCompatibleCloudFeed(String url) {
    // TODO: implement isCompatibleCloudFeed
    throw UnimplementedError();
  }

  @override
  Future<WebSite?> requestCloudFeed(String url) {
    // TODO: implement requestCloudFeed
    throw UnimplementedError();
  }
}
