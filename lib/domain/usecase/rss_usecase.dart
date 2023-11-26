
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/api_usecase.dart';

typedef ErrorMessageCallback = Future<void> Function(String message);

// 今のところはAPIに依存せずにRSSを取得しているがいずれはAPI経由にしてUI関連のみをここに残す
class RssUsecase {
  RssUsecase({
    required this.webRepo,
    required this.apiRepo,
    required this.localRepo,
    required this.apiUsecase,
    required this.noticeError,
    required this.onAddSite,
    required this.progressCallBack,
    required this.rssFeedData,
    required this.userCfg,
  });
  final WebRepositoryInterface webRepo;
  final BackendApiRepository apiRepo;
  final LocalRepositoryInterface localRepo;
  final ApiUsecase apiUsecase;
  Future<void> Function(String message) noticeError;
  Future<void> Function(WebSite site) onAddSite;
  void Function(int count, int all, String msg) progressCallBack;
  WebFeedData rssFeedData;
  final UserConfig userCfg;

  Future<List<Article>?> fetchFeedDetail(
    WebSite site,
    int pageNum, {
    int pageSize = 10,
  }) async {
    if (site.feeds.isEmpty) {
      //PLAN:Repository経由でRss情報を取得する
      //TODO:レポジトリのモックを作る
    } else {
      final res = rssFeedData.pickupRssFeeds(site, pageNum, pageSize);
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

  ///ワードがURLならURL検索、それ以外ならキーワード検索
  Future<SearchResult> searchWord(
    SearchRequest request,
  ) async {
    if (request.word == '') {
      return SearchResult(
        apiResponse: ApiResponseType.refuse,
        responseMessage: '',
        resultType: SearchResultType.error,
        searchType: SearchType.keyword,
        websites: [],
        articles: [],
      );
    }
    userCfg.editRecentSearches(request.word);
    await saveData();
    //ワードがURLかどうか判定する
    if (request.word.contains('http')) {
      //URLならRSS登録処理
      return apiUsecase.search(
        SearchRequest(
          searchType: SearchType.url,
          word: request.word,
        ),
      );
    } else {
      //それ以外ならキーワード検索
      return apiUsecase.search(
        SearchRequest(
          searchType: SearchType.keyword,
          word: request.word,
        ),
      );
    }
  }

  ///データからサイトURLをキーに検索して存在したら返す
  ///
  ///無かったらフィードを更新する
  Future<WebSite> readRssFeed(WebSite site) async {
    if (rssFeedData.anySiteOfURL(site.siteUrl)) {
      final sites = rssFeedData.where((p) => p.siteUrl == site.siteUrl);
      for (final element in sites) {
        if (element.feeds.isEmpty) {
          return refreshRssFeed(element);
        } else {
          //サイトの現在が更新期限よりも新しかったら更新して返す
          if (element.isRssFeedRefreshTime(
            userCfg.appConfig.rssFeedConfig.feedRefreshInterval,
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
    rssFeedData.renameSite(site, newName);
    await saveData();
  }

  ///サイトを登録処理
  Future<void> registerRssSite(List<WebSite> sites) async {
    rssFeedData.add(sites);
    await saveData();
  }

  Future<void> removeRssSite(String deleteCategory, WebSite site) async {
    rssFeedData.deleteSite(deleteCategory, site);
    await saveData();
  }

  Future<void> removeSiteFolder(
    String deleteCategory,
  ) async {
    rssFeedData.deleteFolder(deleteCategory);
    await saveData();
  }

  Future<void> removeSearchHistory(String word) async {
    userCfg.editRecentSearches(word, isAddOrRemove: false);
    await saveData();
  }

  Future<WebSite> refreshRssFeed(WebSite site) async {
    //FIXME:バックエンドが完成するとApiUseCaseを経由するようにする
    final newSite = await webRepo.getFeeds(
      site.siteUrl,
      progressCallBack: progressCallBack,
    );
    rssFeedData.replaceWebSites(site, newSite);
    await saveData();
    return newSite;
  }

  Future<void> saveData() async {
    try {
      await localRepo.saveConfig(userCfg);
      await localRepo.saveFeedData(rssFeedData);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      await noticeError(e.toString());
    }
  }
}
