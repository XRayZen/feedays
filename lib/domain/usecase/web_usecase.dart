// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/mock/gen_data.dart';
import 'package:feedays/util.dart';

typedef ErrorMessageCallback = Future<void> Function(String message);

class WebUsecase {
  final WebRepositoryInterface webRepo;
  final BackendApiRepository backendApiRepo;
  final RssFeedUsecase rssFeedUsecase;
  Future<void> Function(String message) noticeError;
  Future<void> Function(WebSite site) onAddSite;
  UserConfig userCfg;
  WebUsecase({
    required this.webRepo,
    required this.backendApiRepo,
    required this.rssFeedUsecase,
    required this.noticeError,
    required this.onAddSite,
    required this.userCfg,
  });
  //NOTE:プロバイダー経由でクラス変数に代入できるか試す→出来た
  ///今はテスト用にfakeの`feed`を生成する
  Future<void> genFakeWebsite(WebSite site) async {
    userCfg.rssFeedSites.add([site]);
    userCfg.rssFeedSites.folders.first.children.first.feeds
        .addAll(await genFakeRssFeeds(50));
    userCfg.searchHistory.add('http://blog.esuteru.com/');
  }

  Future<List<RssFeedItem>?> fetchFeedDetail(
    WebSite site,
    int pageNum, {
    int pageSize = 10,
  }) async {
    if (site.feeds.isEmpty) {
      //PLAN:Repository経由でRss情報を取得する
      //TODO:レポジトリのモックを作る
    } else {
      final res = userCfg.rssFeedSites.pickupRssFeeds(site, pageNum, pageSize);
      if (res is List<RssFeedItem>) {
        //NOTE:詳細と言ってもxml取得時点で十分な情報を得ている
        //要求されたのが非RSSならバックエンドに要求しなければならない
        //アプリ自体にも非RSS取得機能をいくつか(ex:ロイターなどのニュースサイトスクレイピング)搭載する
        //NOTE:今は機能制限をしないが面接時期には制限してマネタイズ施策をアピールする
        return res;
      }
    }
    return null;
  }

  ///ワードがURLならRSS登録処理
  ///それ以外ならクラウドで検索リクエスト
  ///検索リクエストは無制限
  Future<SearchResult> searchWord(
    SearchRequest request,
  ) async {
    userCfg.editRecentSearches(request.word);
    //ワードがURLかどうか判定する
    if (parseUrls(request.word) is List<String>) {
      //存在するか調べて返す
      final meta = await webRepo.fetchSiteOgpMeta(request.word);
      if (userCfg.rssFeedSites.anySiteOfURL(meta.siteUrl)) {
        //あったらRSSを更新する
        final oldSite = userCfg.rssFeedSites
            .where((site) => site.siteUrl == meta.siteUrl)
            .first;
        //置き換える
        final newSite = await rssFeedUsecase.refreshRss(oldSite);
        userCfg.rssFeedSites.replaceWebSites(oldSite, newSite);
        return SearchResult(
          apiResponse: ApiResponseType.accept,
          responseMessage: '',
          resultType: SearchResultType.found,
          searchType: SearchType.addContent,
          websites: [newSite],
          articles: [],
        );
      } else {
        //なかったらRSS登録処理
        final resParseRssSite = await rssFeedUsecase.parseRss(request.word);
        if (resParseRssSite is WebSite) {
          //リザルトはサイトを返す
          //登録するかはUIで判断できるようにする
          return SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: '',
            resultType: SearchResultType.found,
            searchType: SearchType.addContent,
            websites: [resParseRssSite],
            articles: [],
          );
        } else {
          //非RSSならクラウドフィード対応か問い合わせる
          //クラウドフィードとはアプリ内からではなくapi経由でフィードを取得する方法
          //クライアントは許容された範囲内でapiにリクエストしてフィードを取得できる
          // TODO: implement requestCloudFeed
          throw UnimplementedError();
          //非対応ならUIでRefuseを通知する
        }
      }
    } else {
      //検索程度ならワードでも制限をかけないが将来的な可能性を考慮すると
      //クラウドリクエスト中間クラスで制限設定を参照しながらリクエスト可否を判定したい
      final res = await backendApiRepo.searchWord(
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
  }

  ///サイトを登録処理
  void registerRssSite(WebSite site) {
    userCfg.rssFeedSites.add([site]);
    //PLAN:後々永続化処理
  }
}
