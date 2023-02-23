// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';

class RssFeedUsecase {
  final WebRepositoryInterface webRepo;
  RssFeedUsecase({
    required this.webRepo,
  });
  final addPaths = [
    '/index.rdf',
    '/news/rss_2.0/',
    '/feed/',
    '/rssfeeder/',
    'index.xml',
    '/rss/index.rdf'
  ];

  ///RSSを更新する
  Future<WebSite> refreshRss(WebSite site) async {
    final newFeedItems = await convertFeedLinkToRssItems(site.rssUrl);
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
        site.newCount++;
        newItems.add(newItem);
      }
    }
    //カウントしたら新しいのをインサートする
    site.feeds.addAll(newItems);
    return site;
  }

  ///WebSiteのRSSリンクを解析してRSSFeedで返す<br/>
  ///無効ならnull
  Future<WebSite?> parseRss(String url) async {
    //下記URLでデータを取得できたら購読できる
    final rssPath = await anyRssPath(url);
    if (rssPath is String) {
      // ignore: prefer_final_locals
      var site = await webRepo.fetchSiteOgpMeta(url);
      site
        ..feeds = await convertFeedLinkToRssItems(rssPath)
        ..rssUrl = rssPath;
      return site;
    } else {
      return null;
    }
  }

  ///有効なRSSリンクを返す
  Future<String?> anyRssPath(String url) async {
    for (final element in addPaths) {
      var path = '';
      if (url.endsWith('/')) {
        final lastIndex = url.length;
        path = url.replaceRange(
          lastIndex,
          null,
          element,
        );
      } else {
        //URL末尾に/が無いのなら
        path = url + element;
      }
      if (await webRepo.anyPath(path)) {
        return path;
      }
    }
    return null;
  }

  Future<List<RssFeedItem>> convertFeedLinkToRssItems(String url) async {
    final data = await webRepo.fetchHttpByteData(url);
    final xml = utf8.decode(data.buffer.asUint8List());
    final rss = RssFeed.parse(xml);
    final items = <RssFeedItem>[];
    for (var i = 0; i < rss.items!.length; i++) {
      final item = rss.items![i];
      //サムネ画像を取得するためにリンクhtmlを読み込んでjpg画像リンクをパースして
      //それのリンクを入れてUI時にダウンロードして表示する
      final ogpLink = await webRepo.getOGPImageUrl(item.link!);
      String imageLink;
      if (item.content != null) {
        imageLink = item.content!.images.first;
      } else {
        imageLink = ogpLink ?? '';
      }
      items.add(
        RssFeedItem(
          index: i,
          title: item.title ?? '',
          description: item.description ?? '',
          link: item.link ?? '',
          image: RssFeedImage(link: imageLink, image: ByteData(0)),
          site: rss.title ?? '',
          category: rss.dc?.subject ?? '',
          lastModified:
              item.pubDate ?? item.dc?.date ?? DateTime.utc(2000, 1, 1, 1, 1),
        ),
      );
    }
    return items;
  }
}
