// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

///フィード・サイトリストへの操作を集中して実装する
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
  List<Article>? pickupRssFeeds(WebSite site, int pageNum, int pageMax) {
    if (anySiteOfURL(site.siteUrl)) {
      final list = <Article>[];
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

  ///サイトを上書きして置き換える
  ///フォルダーごとにサイトを探して上書きする
  void replaceWebSites(WebSite oldSite, WebSite newSite) {
    for (var i = 0; i < folders.length; i++) {
      if (folders[i]
          .children
          .any((element) => element.siteUrl == oldSite.siteUrl)) {
        //置き換えずfeed他を更新するだけ
        final siteIndex =
            folders[i].children.indexWhere((e) => e.siteUrl == oldSite.siteUrl);
        oldSite
          ..feeds = newSite.feeds
          // ..name = newSite.name
          ..lastModified = newSite.lastModified;
        folders[i].children[siteIndex] = oldSite;
        folders[i].children.sort((a, b) => a.index.compareTo(b.index));
      }
    }
  }

  void add(List<WebSite> sites) {
    for (final site in sites) {
      _addSite(site, folderName: site.category);
    }
  }

  void _addSite(WebSite site, {String folderName = ''}) {
    //フォルダ未指定ならUnCategorized
    if (folderName == '') {
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
        final folderIndex =
            folders.indexWhere((element) => element.name == folderName);
        folders[folderIndex].children.add(site);
        // ここでインデックスを付ける
        final siteIndex = folders[folderIndex]
            .children
            .indexWhere((element) => element.siteUrl == site.siteUrl);
        folders[folderIndex].children[siteIndex].index = siteIndex;
      } else {
        folders.add(WebSiteFolder(name: folderName, children: [site]));
      }
    }
  }

  void deleteSite(String deleteCategory, WebSite site) {
    if (anySiteOfURL(site.siteUrl)) {
      final index =
          folders.indexWhere((element) => element.name == deleteCategory);
      folders[index]
          .children
          .removeWhere((element) => element.siteUrl == site.siteUrl);
    }
  }

  List<Article>? searchSiteFeedList(String siteUrl) {
    if (anySiteOfURL(siteUrl)) {
      final res = where((p) => p.siteUrl == siteUrl).first.feeds;
      if (res.isNotEmpty) {
        return res;
      }
    }
    return null;
  }

  void addFolder(String folderName) {
    folders.add(WebSiteFolder(name: folderName, children: []));
  }

  void deleteFolder(String folderName) {
    folders.removeWhere((element) => element.name == folderName);
  }

  //サイトの名前を変更する
  //フォルダーごとにサイトを探して上書きする
  void renameSite(WebSite site, String newName) {
    for (var i = 0; i < folders.length; i++) {
      if (folders[i]
          .children
          .any((element) => element.siteUrl == site.siteUrl)) {
        final siteIndex =
            folders[i].children.indexWhere((e) => e.siteUrl == site.siteUrl);
        folders[i].children[siteIndex].name = newName;
      }
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
    required this.siteName,
    this.rssUrl = '',
    required this.iconLink,
    this.newCount = 0,
    this.readLateCount = 0,
    this.category = '',
    required this.tags,
    required this.feeds,
    this.fav = false,
    required this.description,
    this.isCloudFeed = false,
    required this.lastModified,
  });
  factory WebSite.mock(String key, String name, String category) {
    return WebSite(
      key: key,
      name: name,
      siteUrl: key,
      siteName: key,
      category: category,
      tags: List.empty(growable: true),
      feeds: List.empty(growable: true),
      iconLink: '',
      description: 'fake mock',
      lastModified: DateTime.now().toLocal(),
    );
  }

  ///現在が更新期限よりも新しかったら更新する
  ///
  ///更新期限は最終更新日時+limitTime
  bool isRssFeedRefreshTime(
    int limitTime,
  ) {
    //更新期限は最終更新日時+limitTime
    final refreshExpireTime = lastModified
        .toLocal()
        .add(Duration(minutes: limitTime))
        .millisecondsSinceEpoch;
    if (refreshExpireTime < DateTime.now().toLocal().millisecondsSinceEpoch) {
      return true;
    } else {
      return false;
    }
  }

  int index;
  final String key;
  String name;
  final String siteUrl;
  String siteName;
  String rssUrl;
  final String iconLink;
  int newCount;
  int readLateCount;
  String category;
  List<String> tags;
  List<Article> feeds;
  bool fav;
  String description;
  bool isCloudFeed;

  ///最終更新日時
  DateTime lastModified;
}

class Article {
  Article({
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
  RssFeedImage image;
  final String site;
  DateTime lastModified;
  bool isReedLate;

  ///カテゴリーは取得の際につけられる
  final String category;
}

class RssFeedImage {
  RssFeedImage({
    required this.link,
    required this.image,
  });
  final String link;
  final ByteData? image;
}

class FeedObject {
  List<Article> items;
  String title;
  String siteLink;
  String feedLink;
  String description;
  String category;
  String? iconLink;
  FeedObject({
    required this.items,
    required this.title,
    required this.siteLink,
    required this.feedLink,
    required this.description,
    required this.category,
    this.iconLink,
  });
}
