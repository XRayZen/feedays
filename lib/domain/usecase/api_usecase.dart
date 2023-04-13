// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_catches_without_on_clauses
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';

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

  Future<void> registerUser(UserConfig cfg) async {
    //初回起動時にユーザー登録を行う
  }

  Future<void> syncConfig(UserConfig cfg) async {
    //
  }

  String getSyncCode() {
    //現時点では同期コードはユーザーIDをそのまま返す
    return userCfg.userID;
  }

  void codeSync(String? code) {
    //Apiにリクエストして設定を受け取り、上書き更新する
  }

  //アクテビティを報告する
  //PLAN:後回し
  Future<void> reportActivity() async {
    //アクテビティを保存する
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

  //サイトのフィードを取得する
  Future<WebSite?> fetchCloudFeed(WebSite requestSite) async {
    // フィード取得はApi設定で更新頻度を制限
    // 1. WebSiteの最終更新日時が設定値より古い場合は更新
    if (requestSite.isRssFeedRefreshTime(
      userCfg.appConfig.apiRequestConfig.fetchRssFeedRequestLimit,
    )) {
      try {
        // 2. フィード取得
        final res = await backendApiRepo.fetchCloudFeed(requestSite.siteUrl);
        switch (res.responseType) {
          case ApiResponseType.refuse:
            //更新が無いか、何らかの理由で拒否された場合は通知した後は特に何もしない
            await noticeError(res.error);
            return null;
          case ApiResponseType.accept:
            requestSite.feeds.addAll(res.feeds);
            // 3. フィード取得日時を更新
            requestSite.lastModified = DateTime.now().toUtc();
            return requestSite;
        }
      } catch (e) {
        //APIに送信するときにエラーが発生した場合
      }
    }
    return null;
  }

  //検索ページの入力履歴を送信する
  Future<void> editRecentSearches(
    String text, {
    bool isAddOrRemove = true,
  }) async {
    try {
      //入力履歴を保存する
      //Responseを受け取っても対応する必要があるのか
      await backendApiRepo.editRecentSearches(
        text,
        isAddOrRemove: isAddOrRemove,
      );
    } catch (e) {
      //APIに送信するときにエラーが発生した場合
    }
  }

  //サイトを購読・削除する
  Future<void> subscribedSite(
    WebSite site, {
    bool isAddOrRemove = true,
  }) async {
    try {
      //購読サイトを保存する
      //Responseを受け取っても対応する必要があるのか
      await backendApiRepo.subscribeSite(site, isAddOrRemove);
    } catch (e) {
      //APIに送信するときにエラーが発生した場合
    }
  }
  // サイトお気に入りを追加・削除する
  Future<void> favoriteSite(
    WebSite site, {
    bool isAddOrRemove = true,
  }) async {
    try {
      //お気に入りサイトを保存する
      //Responseを受け取っても対応する必要があるのか
      await backendApiRepo.favoriteSite(site, isAddOrRemove);
    } catch (e) {
      //APIに送信するときにエラーが発生した場合
    }
  }

  //記事お気に入りを追加・削除する
  Future<void> favoriteArticle(
    Article feed, {
    bool isAddOrRemove = true,
  }) async {
    try {
      //お気に入り記事を保存する
      //Responseを受け取っても対応する必要があるのか
      await backendApiRepo.favoriteArticle(feed, isAddOrRemove);
    } catch (e) {
      //APIに送信するときにエラーが発生した場合
    }
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
