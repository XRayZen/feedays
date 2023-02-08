
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

class BackendApiRepoImpl extends BackendApiRepository {
  @override
  Future<bool> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<SearchResult> searchWord(SearchRequest request) {
    // TODO: implement searchWord
    throw UnimplementedError();
  }

  @override
  Future<bool> userRegister(UserIdentInfo identInfo) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

}
