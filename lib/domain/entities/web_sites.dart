// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

///フィード・サイトリストの操作を集中して実装する
class RssWebSites {
  List<WebSite> sites;
  RssWebSites({
    required this.sites,
  });

  bool anySiteOfURL(String url) =>
      sites.any((element) => element.siteUrl == url);
  Iterable<WebSite> where(bool Function(WebSite) function) =>
      sites.where(function);

  ///ページ数がサイトのフィード数を上回るのならラスト
  bool isLastFeed(WebSite site, int pageNum) {
    if (sites.any((element) => element.name == site.name)) {
      return sites
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
  List<RssFeedItem>? pickupRssFeeds(WebSite site, int pageNum, int pageMax) {
    if (anySiteOfURL(site.siteUrl)) {
      final list = <RssFeedItem>[];
      for (final element
          in where((element) => element.name == site.name).first.feeds) {
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

  ///サイトの入れ替え
  void onReorderWebSite(String movedItemKey, int oldIndex, int newIndex) {
    //
  }
  void onReorderCategorySite(
    String oldCategory,
    String newCategory,
    String movedItemKey,
  ) {
    //TODO:WebSiteリストをカテゴリー別にツリーノード化させるか検討
    //順位入れ替えを永続化させるため
  }

  //サイトの置き換え
  void replaceWebSites(WebSite oldSite, WebSite newSite) {
    sites
      ..remove(oldSite)
      ..add(newSite);
  }

  void addSite(WebSite site) {
    sites.add(site);
  }
}

class WebSite {
  WebSite({
    required this.key,
    required this.name,
    required this.siteUrl,
    this.rssUrl = '',
    this.icon,
    required this.iconLink,
    this.newCount = 0,
    this.readLateCount = 0,
    required this.category,
    required this.tags,
    required this.feeds,
    this.fav = false,
    required this.description,
    this.isCloudFeed = false,
  });
  factory WebSite.mock(String key, String name, String category) {
    return WebSite(
      key: key,
      name: name,
      siteUrl: '',
      category: category,
      tags: List.empty(growable: true),
      feeds: List.empty(growable: true),
      iconLink: '',
      description: 'fake mock',
    );
  }
  final String key;
  final String name;
  final String siteUrl;
  String rssUrl;
  final ByteData? icon;
  final String iconLink;
  int newCount;
  int readLateCount;
  String category;
  List<String> tags;
  List<RssFeedItem> feeds;
  bool fav;
  final String description;
  bool isCloudFeed;
}

class RssFeedItem {
  RssFeedItem({
    required this.index,
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.site,
    required this.category,
    required this.lastModified,
    this.isReedLate = false,
  });
  final int index;
  final String title;
  final String description;
  final String link;
  final RssFeedImage image;
  final String site;
  final DateTime lastModified;
  bool isReedLate;

  ///必要ないかも
  final String category;
}

class RssFeedImage {
  RssFeedImage({
    required this.link,
    required this.image,
  });
  final String link;
  final ByteData image;
}
