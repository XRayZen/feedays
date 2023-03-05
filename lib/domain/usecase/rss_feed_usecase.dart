// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
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
    '/rssfeeder/',
    'index.xml',
    '/rss/index.rdf'
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

  ///有効なRSSリンクを返す
  Future<String?> anyRssPath(String url) async {
    for (final element in addPaths) {
      var path = '';
      if (url.endsWith('/')) {
        final lastIndex = url.length;
        path = url.replaceRange(
          lastIndex - 1,
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

  Future<WebSite> fetchRss(String siteUrl) async {
    final rssPath = await anyRssPath(siteUrl);
    if (rssPath == null) {
      throw Exception('Not Found Rss URL: $siteUrl');
    }
    //サイト自体のイメージを取得する必要がある
    final meta = await webRepo.fetchSiteOgpMeta(siteUrl);
    final data = await webRepo.fetchHttpByteData(rssPath);
    final xml = utf8.decode(data.buffer.asUint8List());
    final rss = RssFeed.parse(xml);
    final items = List<RssFeedItem>.empty(growable: true);
    if (rss.items != null && rss.items!.isNotEmpty) {
      var index = 0;
      for (final item in rss.items!) {
        var imageLink = '';
        if (item.content!=null&&item.content!.images.isNotEmpty) {
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
            image: RssFeedImage(link: imageLink, image:null),
            site: rss.title ?? '',
            category: rss.dc?.subject ?? '',
            lastModified:
                item.pubDate ?? item.dc?.date ?? DateTime.utc(2000, 1, 1, 1, 1),
          ),
        );
        index++;
      }
    }
    return WebSite(
      key: rss.link!,
      name: rss.title!,
      siteUrl: rss.link!,
      iconLink: meta.iconLink,
      rssUrl: rssPath,
      category: '',
      tags: [],
      feeds: items,
      description: rss.description ?? '',
    );
  }
}
