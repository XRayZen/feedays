// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:html/parser.dart' show parse;
import 'package:webfeed/domain/rss_feed.dart';

class RssFeedUsecase {
  final WebRepositoryInterface webRepo;
  RssFeedUsecase({
    required this.webRepo,
  });
  final addPaths = [
    '/index.rdf',
    '/news/rss_2.0/',
    '/feed/',
    '/feed',
    '/rss',
    '/rssfeeder/',
    '/index.xml',
    '/rss/index.rdf',
    '/rss/index.xml',
    '/feed.xml',
    '/?xml',
    '/rss/new/20/index.xml',
  ];

  ///RSSを更新する
  Future<WebSite?> refreshRss(WebSite site) async {
    //新規サイトを取得
    if (site.rssUrl.isEmpty) {
      final res = await fetchRss(site.siteUrl);
      res.newCount = res.feeds.length;
      return res;
    }
    //既存サイトを更新する
    final newFeedItems =
        await fetchRss(site.siteUrl).then((value) => value.feeds);
    if (site.feeds.isEmpty) {
      site.feeds.addAll(newFeedItems);
      site.newCount = newFeedItems.length;
      return site;
    }
    //既存と比べて新しいフィードをカウントする
    site.newCount = 0;
    // ignore: omit_local_variable_types, prefer_final_locals
    List<RssFeedItem> newItems = <RssFeedItem>[];
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

  ///有効なRSSFeedを返す
  Future<RssFeed?> getRssFeed(String url) async {
    if (await webRepo.anyPath(url)) {
      try {
        final data = await webRepo.fetchHttpByteData(url);
        final rss = RssFeed.parse(utf8.decode(data.buffer.asUint8List()));
        if (rss.items != null) {
          return rss;
        }
      } on Exception catch (_) {
        //RSSではないのならRSS抽出処理を継続する
      }
    }
    //サイトHTMLからRSSLinkを抽出する
    //もしUTF8変換エラーならRawにして先にRSSFeedを取得してサイトメタを構成する
    var data = '';
    try {
      data = await webRepo.fetchHttpString(url, false);
    } on Exception catch (_) {
      //4Gamerなどの一部２バイト文字サイトはutf8変換出来ないからRSSからMetaを生成するしかない
      //flutterのhttp系パッケージは２バイト文字サイトにはほとんど使い物にならないゴミとなる
      data = await webRepo.fetchHttpString(url, true);
      final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
      final rssUrl = extractRSSLinkFromWebsite(
        docBaseSiteMeta.siteName,
        parse(data),
        RSSorAtom.rss,
      );
      //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
      if (await webRepo.anyPath(url + rssUrl)) {
        final rssData = await webRepo.fetchHttpByteData(url + rssUrl);
        final rss = RssFeed.parse(utf8.decode(rssData.buffer.asUint8List()));
        if (rss.items != null) {
          return rss;
        }
      } else if (await webRepo.anyPath(rssUrl)) {
        final rssData = await webRepo.fetchHttpByteData(rssUrl);
        final rss = RssFeed.parse(utf8.decode(rssData.buffer.asUint8List()));
        if (rss.items != null) {
          return rss;
        }
      }
    }
    final meta = await webRepo.fetchSiteOgpMeta(url);
    if (meta.feeds.isNotEmpty) {
      return meta;
    }
    final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
    final rssUrl = extractRSSLinkFromWebsite(
        docBaseSiteMeta.siteName, parse(data), RSSorAtom.rss);
    //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
    if (!rssUrl.contains('://')) {
      final rssData = await webRepo.fetchHttpByteData(url + rssUrl);
      final rss = RssFeed.parse(utf8.decode(rssData.buffer.asUint8List()));
      if (rss.items != null) {
        return rss;
      }
    }
    final rssData = await webRepo.fetchHttpByteData(rssUrl);
    final rss = RssFeed.parse(utf8.decode(rssData.buffer.asUint8List()));
    if (rss.items != null) {
      return rss;
    }
    //ここでRSSLinkを割り出しているが確実ではない
    //念のために残しておく
    // for (final element in addPaths) {
    //   var urlPath = '';
    //   if (url.endsWith('/')) {
    //     final lastIndex = url.length;
    //     urlPath = url.replaceRange(
    //       lastIndex - 1,
    //       null,
    //       element,
    //     );
    //   } else {
    //     //URL末尾に/が無いのなら
    //     urlPath = url + element;
    //   }
    //   if (await webRepo.anyPath(urlPath)) {
    //     //もしサイトが存在してもRSSがパース出来ないのなら無効
    //     try {
    //       //
    //       final data = await webRepo.fetchHttpByteData(url);
    //       final rss = RssFeed.parse(utf8.decode(data.buffer.asUint8List()));
    //       if (rss.items != null) {
    //         return rss;
    //       }
    //     } on Exception catch (e) {}
    //   }
    // }
    return null;
  }

  Future<WebSite> fetchRss(String siteUrl) async {
    final meta = await webRepo.fetchSiteOgpMeta(siteUrl);
    final rssFeed = await getRssFeed(siteUrl);
    if (rssFeed == null) {
      throw Exception('Not Found Rss URL: $siteUrl');
    }
    final items = List<RssFeedItem>.empty(growable: true);
    if (rssFeed.items != null && rssFeed.items!.isNotEmpty) {
      var index = 0;
      for (final item in rssFeed.items!) {
        var imageLink = '';
        if (item.content != null && item.content!.images.isNotEmpty) {
          imageLink = item.content!.images.first;
        } else {
          //ここはHtmlを取得してパースしているから重い
          imageLink = await webRepo.getOGPImageUrl(item.link!) ?? '';
        }
        items.add(
          RssFeedItem(
            index: index,
            title: item.title ?? '',
            description: item.description ?? '',
            link: item.link ?? '',
            image: RssFeedImage(link: imageLink, image: null),
            site: rssFeed.title ?? '',
            category: rssFeed.dc?.subject ?? '',
            lastModified:
                item.pubDate ?? item.dc?.date ?? DateTime.utc(2000, 1, 1, 1, 1),
          ),
        );
        index++;
      }
    }
    return WebSite(
      key: rssFeed.link!,
      name: rssFeed.title!,
      siteUrl: rssFeed.link!,
      siteName: meta.siteName,
      iconLink: meta.iconLink,
      rssUrl: rssFeed.link ?? '',
      category: '',
      tags: [],
      feeds: items,
      description: rssFeed.description ?? '',
    );
  }
}
