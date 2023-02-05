// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/mock/gen_data.dart';

class WebUsecase {
  final WebRepositoryInterface repo;
  WebUsecase({
    required this.repo,
  });
  //プロバイダー経由でクラス変数に代入できるか試す→出来た
  List<WebSite> webSites = [];

  ///今はテスト用にfakeの`feed`を生成する
  void genFakeWebsite(WebSite site) {
    webSites.add(site);
    webSites.first.feeds.addAll(genFakeRssFeeds(50));
  }

  ///リストから指定された上限と下限の件数を抜き出す
  List<RssFeed>? fetchFeedDetail(WebSite site, int pageNum,
      {int pageSize = 10}) {
    if (webSites.any((element) => element.name == site.name)) {
      List<RssFeed> list = [];
      for (var element in webSites
          .firstWhere((element) => element.name == site.name)
          .feeds) {
        if (element.index > pageNum) {
          list.add(element);
        }
        if (list.length > pageSize) {
          break;
        }
      }
      return list;
    } else {
      return null;
    }
  }

  ///ページ数がサイトのフィード数を上回るのならラスト
  bool isLastFeed(WebSite site, int pageNum) {
    if (webSites.any((element) => element.name == site.name)) {
      return webSites
              .firstWhere((element) => element.name == site.name)
              .feeds
              .length <=
          pageNum;
    } else {
      return false;
    }
  }
}
