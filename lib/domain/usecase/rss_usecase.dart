// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/api_usecase.dart';
import 'package:feedays/util.dart';

typedef ErrorMessageCallback = Future<void> Function(String message);

class RssUsecase {
  final WebRepositoryInterface webRepo;
  final BackendApiRepository apiRepo;
  final LocalRepositoryInterface localRepo;
  final ApiUsecase apiUsecase;
  Future<void> Function(String message) noticeError;
  Future<void> Function(WebSite site) onAddSite;
  void Function(int count, int all, String msg) progressCallBack;
  final UserConfig userCfg;
  RssUsecase({
    required this.webRepo,
    required this.apiRepo,
    required this.localRepo,
    required this.apiUsecase,
    required this.noticeError,
    required this.onAddSite,
    required this.progressCallBack,
    required this.userCfg,
  });

  Future<List<Article>?> fetchFeedDetail(
    WebSite site,
    int pageNum, {
    int pageSize = 10,
  }) async {
    if (site.feeds.isEmpty) {
      //PLAN:Repository経由でRss情報を取得する
      //TODO:レポジトリのモックを作る
    } else {
      final res = userCfg.rssFeedSites.pickupRssFeeds(site, pageNum, pageSize);
      if (res is List<Article>) {
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
    if (request.word == '') {
      return SearchResult(
        apiResponse: ApiResponseType.refuse,
        responseMessage: '',
        resultType: SearchResultType.error,
        searchType: SearchType.addContent,
        websites: [],
        articles: [],
      );
    }
    userCfg.editRecentSearches(request.word);
    await saveData();
    //ワードがURLかどうか判定する
    if (parseUrls(request.word) is List<String>) {
      //URLなら既存のデータベースに存在するか調べて返す
      if (userCfg.rssFeedSites.anySiteOfURL(request.word)) {
        final foundSite = userCfg.rssFeedSites
            .where((site) => site.siteUrl == request.word)
            .first;
        //もし、RSSがあるのならリプレースせずそのまま返す
        if (foundSite.feeds.isNotEmpty) {
          return SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: '',
            resultType: SearchResultType.found,
            searchType: SearchType.addContent,
            websites: [foundSite],
            articles: [],
          );
        } else {
          //無かったらリプレースして置き換える
          final newSite = await refreshRssFeed(foundSite);
          return SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: '',
            resultType: SearchResultType.found,
            searchType: SearchType.addContent,
            websites: [newSite],
            articles: [],
          );
        }
      } else {
        //データに無かったらRSS登録処理
        try {
          final newSite = await webRepo.getFeeds(
            request.word,
            progressCallBack: progressCallBack,
          );
          //リザルトはサイトを返す
          //登録するかはUIで判断できるようにする
          return SearchResult(
            apiResponse: ApiResponseType.accept,
            responseMessage: '',
            resultType: SearchResultType.found,
            searchType: SearchType.addContent,
            websites: [newSite],
            articles: [],
          );
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          //非RSSならクラウドフィード対応か問い合わせる
          //クラウドフィードとはアプリ内からではなくapi経由でフィードを取得する方法
          //クライアントは許容された範囲内でapiにリクエストしてフィードを取得できる
          //TODO: implement requestCloudFeed
          throw UnimplementedError();
          //非対応ならUIでRefuseを通知する
        }
      }
    } else {
      //クラウドリクエスト中間クラス(APIUseCase)で制限設定を参照しながらリクエスト可否を判定
      //ApiUsecsse経由でリクエストする
      //エラー処理はApiUseCaseで行う
      return apiUsecase.search(request);
    }
  }

  ///データからサイトURLをキーに検索して存在したら返す
  ///
  ///無かったらフィードを更新する
  Future<WebSite> readRssFeed(WebSite site) async {
    if (userCfg.rssFeedSites.anySiteOfURL(site.siteUrl)) {
      final sites =
          userCfg.rssFeedSites.where((p) => p.siteUrl == site.siteUrl);
      for (final element in sites) {
        if (element.feeds.isEmpty) {
          return refreshRssFeed(element);
        } else {
          //サイトの現在が更新期限よりも新しかったら更新して返す
          if (element.isRssFeedRefreshTime(
            userCfg.appConfig.rssFeedConfig.limitLastFetchTime,
          )) {
            return refreshRssFeed(element);
          } else {
            return element;
          }
        }
      }
    }
    //無かったら取得する
    return refreshRssFeed(site);
  }

  Future<WebSite> addNewSite(String url) async {
    final newSite = await webRepo.getFeeds(
      url,
      progressCallBack: progressCallBack,
    );
    await registerRssSite([newSite]);
    return newSite;
  }

  Future<void> renameSite(WebSite site, String newName) async {
    userCfg.rssFeedSites.renameSite(site, newName);
    await saveData();
  }

  ///サイトを登録処理
  Future<void> registerRssSite(List<WebSite> sites) async {
    userCfg.rssFeedSites.add(sites);
    await saveData();
  }

  Future<void> removeRssSite(String deleteCategory, WebSite site) async {
    userCfg.rssFeedSites.deleteSite(deleteCategory, site);
    await saveData();
  }

  Future<void> removeSiteFolder(
    String deleteCategory,
  ) async {
    userCfg.rssFeedSites.deleteFolder(deleteCategory);
    await saveData();
  }

  Future<void> removeSearchHistory(String word) async {
    userCfg.editRecentSearches(word, isAddOrRemove: false);
    await saveData();
  }

  Future<WebSite> refreshRssFeed(WebSite site) async {
    final newSite = await webRepo.getFeeds(
      site.siteUrl,
      progressCallBack: progressCallBack,
    );
    userCfg.rssFeedSites.replaceWebSites(site, newSite);
    await saveData();
    return newSite;
  }

  Future<void> saveData() async {
    try {
      await localRepo.saveConfig(userCfg);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      await noticeError(e.toString());
    }
  }
}
