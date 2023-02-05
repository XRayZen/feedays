// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase.dart';
import 'package:feedays/mock/gen_data.dart';
import 'package:flutter/services.dart';

class WebUsecase {
  final WebRepositoryInterface repo;
  WebUsecase({
    required this.repo,
  });
  //TODO:プロバイダー経由でクラス変数に代入できるか試す
  List<WebSite> webSites = [];

  ///今はテスト用にfakeの`feed`を生成する
  void genFakeWebsite() {
    webSites.add(WebSite.mock("fake", "name", "category"));
    webSites[0].feeds.addAll(genFakeRssFeeds(20));
  }

  //
  List<RssFeed>? fetchFeed(WebSite site, int pageNum, {int pageSize=10}) {
    if (webSites.any((element) => element.name == site.name)) {
      //dartでリストから指定された上限と下限の件数を抜き出す
      return webSites
          .firstWhere((element) => element.name == site.name)
          .feeds
          .where((element) =>
              (element.index >= pageNum) || (element.index < pageSize))
          .toList();
    } else {
      return null;
    }
  }

  bool isLastFeed(WebSite site, int pageNum) {
    if (webSites.any((element) => element.name == site.name)) {
      //ページ数がサイトのフィード数を上回るのならラスト
      return webSites
              .firstWhere((element) => element.name == site.name)
              .feeds
              .length <= pageNum;
    } else {
      return false;
    }
  }
}
