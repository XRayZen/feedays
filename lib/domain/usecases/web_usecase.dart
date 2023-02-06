// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/mock/gen_data.dart';

class WebUsecase {
  WebUsecase({required this.repo, required this.user});
  final WebRepositoryInterface repo;
  UserConfig user;
  //NOTE:プロバイダー経由でクラス変数に代入できるか試す→出来た

  ///今はテスト用にfakeの`feed`を生成する
  void genFakeWebsite(WebSite site) {
    user.subscribeSites.add(site);
    user.subscribeSites.first.feeds.addAll(genFakeRssFeeds(50));
  }

  void onReorderSite(String oldCategory, String newCategory,String movedItemKey) {
    //TODO:WebSiteリストをカテゴリー別にツリーノード化させるか検討
    //順位入れ替えを永続化させるため
  }

  Future<List<RssFeed>?> fetchFeedDetail(WebSite site, int pageNum,
      {int pageSize = 10,}) async {
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
    if (user.subscribeSites.any((element) => element.name == site.name)) {
      return user.subscribeSites
              .firstWhere((element) => element.name == site.name)
              .feeds
              .last
              .index <=
          pageNum;
    } else {
      return false;
    }
  }

  ///リストから指定された上限と下限の件数を抜き出す
  List<RssFeed>? _pickupRssFeeds(WebSite site, int pageNum, int pageMax) {
    if (user.subscribeSites.any((element) => element.name == site.name)) {
      final list = <RssFeed>[];
      for (final element in user.subscribeSites
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
