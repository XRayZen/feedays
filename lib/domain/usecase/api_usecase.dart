// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/util.dart';

class ApiUsecase {
  final BackendApiRepository backendApiRepo;
  Future<void> Function(String message) noticeError;
  UserConfig userCfg;
  //ユーザー識別情報はここに保存しておく
  final UserAccessIdentInfo identInfo;
  ApiUsecase({
    required this.backendApiRepo,
    required this.noticeError,
    required this.userCfg,
    required this.identInfo,
  });
  //WARNING:ApiにリクエストするときはUTC現在日時を入れておく

  String getSyncCode() {
    //現時点では同期コードはユーザーIDをそのまま返す
    return userCfg.userID;
  }

  void codeSync(String? code) {
    //Apiにリクエストして設定を受け取り、上書き更新する
  }

  //検索するとき
  Future<SearchResult> search(SearchRequest request) async {
    //クラウド側でワードがURLかそうで無いかを判断して処理をして返す
    final result = await backendApiRepo.searchWord(
      ApiSearchRequest(
        searchType: request.searchType,
        word: request.word,
        userID: userCfg.userID,
        identInfo: identInfo,
        accountType: userCfg.accountType,
        requestTime: DateTime.now().toUtc(),
      ),
    );
    return result;
  }

  Future<List<ExploreCategory>> getCategories() async {
    //ここもカテゴリーを保存しておらず例外処理も十分にしていない
    if (userCfg.categories.isEmpty) {
      final cate = await backendApiRepo.getExploreCategories(identInfo);
      if (cate.isNotEmpty) {
        userCfg.categories = cate;
        //ここでカテゴリが入ったデータを保存する
        return cate;
      } else {
        await noticeError('Not found category');
        return [];
      }
    } else {
      //NOTE:カテゴリ情報はバックエンドが管理するためApiから取るべき
      //PLAN:あとでコンフィグにカテゴリの有効期限を設定する項目をつき加える
      return userCfg.categories;
    }
  }
}
