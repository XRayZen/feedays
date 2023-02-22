// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:webfeed/domain/rss_feed.dart';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';

class RssFeedUsecase {
  final WebRepositoryInterface webRepo;
  RssFeedUsecase({
    required this.webRepo,
  });

  //WebSiteのRSSリンクを解析してRSSFeedで返す
  Future<void> parseRss(String url) async {
    //   - 下記URLでデータを取得できたら購読できる
    // - `/index.rdf`
    // - `/news/rss_2.0/`
    // - `/feed/`
    // - `/rssfeeder/`
    // - `index.xml`
    // - `/rss/index.rdf`
    
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
