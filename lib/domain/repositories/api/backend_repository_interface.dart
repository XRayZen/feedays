import 'dart:ffi';

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';

abstract class BackendApiRepository {
  Future<bool> login();
  Future<bool> userRegister(UserIdentInfo identInfo);
  Future<SearchResult> searchWord(ApiSearchRequest request);
  Future<void> editRecentSearches(String text, {bool isAddOrRemove = true});
}
