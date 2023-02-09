// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/mock/gen_data.dart';
import 'package:feedays/util.dart';

typedef ErrorMessageCallback = Future<void> Function(String message);

class WebUsecase {
  WebUsecase({
    required WebRepositoryInterface webRepo,
    required BackendApiRepository backendApiRepo,
    required this.userCfg,
    required this.noticeError,
  })  : _backendApiRepo = backendApiRepo,
        _webRepo = webRepo;
  final WebRepositoryInterface _webRepo;
  final BackendApiRepository _backendApiRepo;
  Future<void> Function(String message) noticeError;
  UserConfig userCfg;
  //NOTE:プロバイダー経由でクラス変数に代入できるか試す→出来た

  ///今はテスト用にfakeの`feed`を生成する
  void genFakeWebsite(WebSite site) {
    userCfg.subscribeSites.add(site);
    userCfg.subscribeSites.first.feeds.addAll(genFakeRssFeeds(50));
    userCfg.searchHistory.add('40010');
  }

  void onReorderSite(
    String oldCategory,
    String newCategory,
    String movedItemKey,
  ) {
    //TODO:WebSiteリストをカテゴリー別にツリーノード化させるか検討
    //順位入れ替えを永続化させるため
  }

  Future<List<RssFeed>?> fetchFeedDetail(
    WebSite site,
    int pageNum, {
    int pageSize = 10,
  }) async {
    if (site.feeds.isEmpty) {
      //PLAN:Repository経由でRss情報を取得する
      //TODO:レポジトリのモックを作る
    } else {
      final res = _pickupRssFeeds(site, pageNum, pageSize);
      if (res is List<RssFeed>) {
        //NOTE:詳細と言ってもxml取得時点で十分な情報を得ている
        //要求されたのが非RSSならバックエンドに要求しなければならない
        //アプリ自体にも非RSS取得機能をいくつか(ex:ロイターなどのニュースサイトスクレイピング)搭載する
        //NOTE:今は機能制限をしないが面接時期には制限してマネタイズ施策をアピールする
        return res;
      }
    }
    return null;
  }

  ///ページ数がサイトのフィード数を上回るのならラスト
  bool isLastFeed(WebSite site, int pageNum) {
    if (userCfg.subscribeSites.any((element) => element.name == site.name)) {
      return userCfg.subscribeSites
              .firstWhere((element) => element.name == site.name)
              .feeds
              .last
              .index <=
          pageNum;
    } else {
      return false;
    }
  }

  ///ワードがURLならRSS登録処理
  ///それ以外ならクラウドで検索リクエスト
  ///検索リクエストは無制限
  Future<SearchResult> searchWord(
    SearchRequest request,
  ) async {
    _editRecentSearches(request.word);
    //ワードがURLかどうか判定する
    final urlRes = parseUrls(request.word);
    if (urlRes is List<String>) {
      //切り分けているが一つしか処理しない
      //urlならRSS登録をする
      //非RSSならバックエンドに問い合わせてクラウドフィード対応サイトか問い合わせる
    } else {
      //検索程度ならワードでも制限をかけないが将来的な可能性を考慮すると
      //クラウドリクエスト中間クラスで制限設定を参照しながらリクエスト可否を判定したい
      final res = await _backendApiRepo.searchWord(
        ApiSearchRequest(
          searchType: request.searchType,
          queryType: SearchQueryType.word,
          word: request.word,
          userID: userCfg.userID,
          identInfo: userCfg.identInfo,
          accountType: userCfg.accountType,
        ),
      );
      switch (res.apiResponse) {
        case ApiResponseType.refuse:
          //refuseならエラーメッセージを通知する
          //関数形式でエラーメッセージ処理を
          await noticeError(res.responseMessage);
          throw Exception(
            'Api SearchRequest error: ${res.responseMessage}',
          );
        case ApiResponseType.accept:
          return res;
      }
    }
    throw Exception();
  }

  //FIXME:サーチが走るたびにこれを呼べばいいから外部に公開する必要はない
  void _editRecentSearches(String text, {bool isAddOrRemove = true}) {
    if (isAddOrRemove) {
      if (!userCfg.searchHistory.contains(text)) {
        //PLAN:入力履歴はローカル・クラウド両方に保存しておく
        userCfg.searchHistory.add(text);
      }
    } else {
      userCfg.searchHistory.removeWhere((element) => element == text);
    }
  }

  ///リストから指定された上限と下限の件数を抜き出す
  List<RssFeed>? _pickupRssFeeds(WebSite site, int pageNum, int pageMax) {
    if (userCfg.subscribeSites.any((element) => element.name == site.name)) {
      final list = <RssFeed>[];
      for (final element in userCfg.subscribeSites
          .firstWhere((element) => element.name == site.name)
          .feeds) {
        if (element.index > pageNum) {
          list.add(element);
        }
        if (list.length > pageMax) {
          break;
        }
      }
      return list;
    }
    return null;
  }
}
