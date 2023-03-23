// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/infra/datasources/rss_util.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:webfeed/domain/rss_feed.dart';

// https://zenn.dev/tris/articles/9705b93a02425f

String parseImageThumbnail(Document doc) {
  // ヘッダー内のtitleタグの中身を取得
  // ignore: unused_local_variable
  String _description;
  var imageLink = '';
// ヘッダー内のmetaタグをすべて取得
  final metas = doc.head!.getElementsByTagName('meta');

  for (final meta in metas) {
    // metaタグの中からname属性がdescriptionであるものを探す
    if (meta.attributes['name'] == 'description') {
      _description = meta.attributes['content'] ?? '';
      // metaタグの中からproperty属性がog:imageであるものを探す
    } else if (meta.attributes['property'] == 'og:image') {
      imageLink = meta.attributes['content']!;
    }
  }
  return imageLink;
}

enum RSSorAtom { rss, atom }

String extractRSSLinkFromWebsite(
  String siteName,
  Document doc,
  RSSorAtom rssType,
) {
  final links = doc.head!.getElementsByTagName('link');
  if (links.any((e) => e.attributes.containsKey('title'))) {
    final titles = links
        .where((element) => element.attributes.containsKey('title'))
        .toList();
    final maps = <String, String>{};
    for (final e in titles) {
      //titleキーにRSSかAtomという
      //hrefキーにURL
      final titleKey = e.attributes.entries
          .map((el) {
            if (el.key == 'title') {
              return el.value;
            }
          })
          .whereType<String>()
          .first;
      final rssURL = e.attributes.entries
          .map((el) {
            if (el.key == 'href') {
              return el.value;
            }
          })
          .whereType<String>()
          .first;
      maps.addAll({titleKey: rssURL});
    }
    if (maps.containsKey(siteName)) {
      return maps.entries.first.value;
    }
    //TODO:リファクタリング候補 : RSSかAtomを判定する

    switch (rssType) {
      case RSSorAtom.rss:
        {
          if (maps.containsKey('RSS') ||
              maps.containsKey('RSS2.0') ||
              maps.containsKey('RSS1.0')) {
            return maps.entries
                .where(
                  (element) =>
                      element.key == 'RSS' ||
                      element.key == 'RSS2.0' ||
                      element.key == 'RSS1.0',
                )
                .first
                .value;
          }
          return maps.entries.first.value;
        }
      case RSSorAtom.atom:
        if (maps.containsKey('Atom')) {
          return maps.entries
              .where((element) => element.key == 'Atom')
              .first
              .value;
        }
        return maps.entries.first.value;
    }
  } else {
    throw Exception('Invalid RSS Site');
  }
}

///メタタグを解析してサイトメタを読み取る
WebSite parseDocumentToWebSite(
  String siteUrl,
  Document doc,
) {
  final maps = <String, String>{};
  //BUG:２バイト文字が文字化けしてしまう-> utf8で変換してみるが無駄か
  final metas = doc.head!.getElementsByTagName('meta');
  for (final meta in metas) {
    if (meta.attributes['property'] == 'og:site_name') {
      maps.addAll({'SiteName': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:title') {
      maps.addAll({'Title': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:type') {
      maps.addAll({'type': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:url') {
      maps.addAll({'SiteUrl': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:description') {
      maps.addAll({'description': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:image') {
      maps.addAll({'Image': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:keywords') {
      maps.addAll({'Keywords': meta.attributes['content'] ?? ''});
    }
  }
  final tag = maps['SiteUrl'];
  return WebSite(
    key: maps['SiteUrl'] ?? siteUrl,
    name: maps['SiteName'] ?? '',
    siteUrl: maps['SiteUrl'] ?? siteUrl,
    siteName: maps['SiteName'] ?? '',
    iconLink: maps['Image'] ?? '',
    category: maps['type'] ?? '',
    tags: tag != null ? [tag] : [],
    feeds: [],
    description: maps['description'] ?? '',
  );
}

Future<WebSite> parseRssToWebSiteMeta(
  String url,
  WebSite meta,
  RssFeed feed,
) async {
  return WebSite(
    key: feed.link ?? '',
    name: feed.title ?? meta.name,
    siteUrl: feed.link ?? url,
    siteName: feed.title ?? meta.siteName,
    iconLink: meta.iconLink,
    category: meta.category,
    tags: feed.itunes?.keywords ?? [],
    feeds: rssFeedConvert(feed),
    description: feed.description ?? '',
  );
}

Future<List<FeedItem>> parseImageLink(
  WebRepositoryInterface webRepo,
  List<FeedItem> items, {
  void Function(int count, int all, String msg)? progressCallBack,
}) async {
  for (var i = 0; i < items.length; i++) {
    if (items[i].image.link == '') {
      items[i].image = RssFeedImage(
        //ここはHtmlを取得してパースしているから重い
        link: await webRepo.getOGPImageUrl(items[i].link) ?? '',
        image: ByteData(0),
      );
    }
    if (progressCallBack != null) {
      progressCallBack(i, items.length, items[i].link);
    }
  }
  return items;
}

///有効なRSSFeedを返す
Future<FeedObject?> getRssFeed(
  WebRepositoryInterface webRepo,
  String url,
) async {
  if (await webRepo.anyPath(url)) {
    try {
      final data = await webRepo.fetchHttpByte(url);
      final rss = rssDataToRssObj(data, url);
      if (rss != null && rss.items.isNotEmpty) {
        return rss;
      }
    } catch (_) {
      //RSSではないのならRSS抽出処理を継続する
    }
  }
  //サイトHTMLからRSSLinkを抽出する
  //もしUTF8変換エラーならRawにして先にRSSFeedを取得してサイトメタを構成する
  var data = '';
  try {
    data = await webRepo.fetchHttpString(url, isUtf8: true);
  } on Exception catch (_) {
    //4Gamerなどの一部２バイト文字サイトはutf8変換出来ないからRSSからMetaを生成するしかない
    //flutterのhttp系パッケージは２バイト文字サイトにはほとんど使い物にならないゴミとなる
    data = await webRepo.fetchHttpString(url);
    final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
    final rssUrl = extractRSSLinkFromWebsite(
      docBaseSiteMeta.siteName,
      parse(data),
      RSSorAtom.rss,
    );
    //FullPathの場合
    if (await webRepo.anyPath(url + rssUrl)) {
      final rssData = await webRepo.fetchHttpByte(url + rssUrl);
      return rssDataToRssObj(rssData, rssUrl);
    }
    //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
    else if (await webRepo.anyPath(rssUrl)) {
      final rssData = await webRepo.fetchHttpByte(rssUrl);
      return rssDataToRssObj(rssData, rssUrl);
    }
  }
  final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
  var rssUrl = '';
  try {
    rssUrl = extractRSSLinkFromWebsite(
      docBaseSiteMeta.siteName,
      parse(data),
      RSSorAtom.rss,
    );
  } on Exception catch (_) {
    rssUrl = extractRSSLinkFromWebsite(
      docBaseSiteMeta.siteName,
      parse(data),
      RSSorAtom.atom,
    );
  }
  //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
  if (!rssUrl.contains('://')) {
    final rssData = await webRepo.fetchHttpByte(url + rssUrl);
    return rssDataToRssObj(rssData, rssUrl);
  }
  final rssData = await webRepo.fetchHttpByte(rssUrl);
  return rssDataToRssObj(rssData, rssUrl);
}

Future<WebSite> fetchRss(
  WebRepositoryInterface webRepo,
  String siteUrl, {
  void Function(int count, int all, String msg)? progressCallBack,
}) async {
  final meta = await webRepo.fetchSiteOgpMeta(siteUrl);
  // 取得済みなら変換して返す
  if (meta.feeds.isNotEmpty) {
    meta.feeds = await parseImageLink(
      webRepo,
      meta.feeds,
      progressCallBack: progressCallBack,
    );
    return meta;
  }
  final rssFeed = await getRssFeed(webRepo, siteUrl);
  if (rssFeed == null) {
    throw Exception('Not Found Rss URL: $siteUrl');
  }
  return WebSite(
    key: rssFeed.link,
    name: rssFeed.title,
    siteUrl: meta.siteUrl,
    siteName: meta.siteName,
    iconLink: meta.iconLink,
    rssUrl: rssFeed.link,
    tags: [],
    feeds: await parseImageLink(
      webRepo,
      rssFeed.items,
      progressCallBack: progressCallBack,
    ),
    description: rssFeed.description,
  );
}

///RSSを更新する
Future<WebSite?> refreshRssConvert(
    WebRepositoryInterface webRepo, WebSite site) async {
  //新規サイトを取得
  if (site.rssUrl.isEmpty) {
    final res = await fetchRss(webRepo, site.siteUrl);
    res.newCount = res.feeds.length;
    return res;
  }
  //既存サイトを更新する
  final newFeedItems =
      await fetchRss(webRepo, site.siteUrl).then((value) => value.feeds);
  if (site.feeds.isEmpty) {
    site.feeds.addAll(newFeedItems);
    site.newCount = newFeedItems.length;
    return site;
  }
  //既存と比べて新しいフィードをカウントする
  site.newCount = 0;
  // ignore: omit_local_variable_types, prefer_final_locals
  List<FeedItem> newItems = <FeedItem>[];
  for (final newItem in newFeedItems) {
    if (site.feeds.any(
      (x) =>
          x.lastModified.millisecondsSinceEpoch <
          newItem.lastModified.millisecondsSinceEpoch,
    )) {
      //でもURLが同じなのは入れない
      if (!site.feeds.any((x) => x.link == newItem.link)) {
        site.newCount++;
        newItems.add(newItem);
      }
    }
  }
  //カウントしたら新しいのをインサートする
  site.feeds.addAll(newItems);
  return site;
}
