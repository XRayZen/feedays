import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:webfeed/domain/rss_content.dart';
import 'package:webfeed/webfeed.dart';

Future<List<RssFeedItem>> convertXmlToRss(ByteData data) async {
  final xml = utf8.decode(data.buffer.asUint8List());
  final rss = RssFeed.parse(xml);
  final items = <RssFeedItem>[];
  for (var i = 0; i < rss.items!.length; i++) {
    final item = rss.items![i];
    //サムネ画像を取得するためにリンクhtmlを読み込んでjpg画像リンクをパースして
    //それのリンクを入れてUI時にダウンロードして表示する
    final ogpLink = await getOGPImageUrl(item.link!);
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
