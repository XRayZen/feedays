// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

///フィード・サイトリストの操作を集中して実装する
class RssWebSites {
  List<WebSiteFolder> folders;
  RssWebSites({
    required this.folders,
  });

  bool anySiteOfURL(String url) {
    for (final sites in folders) {
      if (sites.children.any((element) => element.siteUrl == url)) {
        return true;
      }
    }
    return false;
  }

  Iterable<WebSite> where(bool Function(WebSite) function) {
    final result = List<WebSite>.empty(growable: true);
    for (final element in folders) {
      result.addAll(element.children.where(function));
    }
    return result;
  }

  ///ページ数がサイトのフィード数を上回るのならラスト
  bool isLastFeed(WebSite site, int pageNum) {
    if (anySiteOfURL(site.siteUrl)) {
      return where((element) => element.name == site.name)
              .first
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

  ///フォルダの入れ替え
  ///onListReorderに相当
  void onReorderFolder(
    int oldFolderIndex,
    int newFolderIndex,
  ) {
    final newList = folders;
    if (oldFolderIndex < newFolderIndex) {
      newFolderIndex -= 1;
    }
    final node = newList.removeAt(oldFolderIndex);
    newList.insert(newFolderIndex, node);
    folders = newList;
  }

  ///onItemReorderに相当<br/>
  ///入れ替えの場合はリストをコピーしてそのリストから入れ替え処理してリストを新規作成する
  void onReorderSiteIndex(
    int fromItemIndex,
    int fromFolderIndex,
    int toItemIndex,
    int toFolderIndex,
  ) {
    //順位入れ替えを永続化させるためWebSiteリストをカテゴリー別にツリーノード化
    final newList = folders;
    final movedItem = newList[fromFolderIndex].children.removeAt(fromItemIndex)
      ..category = newList[toFolderIndex].name;
    newList[toFolderIndex].children.insert(toItemIndex, movedItem);
    folders = newList;
  }

  //サイトの上書きして置き換える
  void replaceWebSites(WebSite oldSite, WebSite newSite) {
    for (var i = 0; i < folders.length; i++) {
      if (folders[i]
          .children
          .any((element) => element.siteUrl == oldSite.siteUrl)) {
        folders[i]
            .children
            .removeWhere((element) => element.siteUrl == oldSite.siteUrl);
        folders[i].children.add(newSite);
      }
    }
  }

  void add(List<WebSite> sites) {
    for (final site in sites) {
      _addSite(site, folderName: site.category);
    }
  }

  void _addSite(WebSite site, {String? folderName}) {
    if (anySiteOfURL(site.siteUrl)) {
      return;
    }
    //フォルダ未指定ならUnCategorized
    if (folderName == null) {
      if (folders.any((element) => element.name != 'UnCategorized') ||
          folders.isEmpty) {
        folders.add(WebSiteFolder(name: 'UnCategorized', children: [site]));
      } else {
        final index =
            folders.indexWhere((element) => element.name == 'UnCategorized');
        folders[index].children.add(site);
      }
    }
    //指定なら入れる 新規フォルダなら追加
    else {
      if (folders.any((element) => element.name == folderName)) {
        final index =
            folders.indexWhere((element) => element.name == folderName);
        folders[index].children.add(site);
      } else {
        folders.add(WebSiteFolder(name: folderName, children: [site]));
      }
    }
  }

  void deleteSite(WebSite site) {
    if (anySiteOfURL(site.siteUrl)) {
      final index =
          folders.indexWhere((element) => element.name == site.category);
      folders[index].children.remove(site);
    }
  }
}

class WebSiteFolder {
  String name;
  List<WebSite> children;
  WebSiteFolder({
    required this.name,
    required this.children,
  });
}

class WebSite {
  WebSite({
    this.index = 0,
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
      siteUrl: key,
      category: category,
      tags: List.empty(growable: true),
      feeds: List.empty(growable: true),
      iconLink: '',
      description: 'fake mock',
    );
  }
  int index;
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