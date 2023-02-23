import 'dart:convert';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/foundation.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:webfeed/webfeed.dart';

import 'gen_data.dart';

Future<List<RssFeedItem>> genFakeRssFeeds(int num, String word) async {
  final feeds = List<RssFeedItem>.empty(growable: true);
  for (var i = 0; i < num; i++) {
    feeds.add(
      RssFeedItem(
        index: i,
        title: 'fake:{$i} key:{$word}',
        description: 'fake description',
        link:
            'https://wired.jp/article/fast-forward-the-chatbot-search-wars-have-begun/',
        image: RssFeedImage(
          link: 'assets/confused-face.png',
          image: await getAssetData('assets/confused-face.png'),
        ),
        site: 'fakeSite:{$i}',
        category: 'MockedCategory',
        lastModified: DateTime.now(),
      ),
    );
  }
  return feeds;
}

//Web系を静的で実装する
Future<ByteData> fetchHttpByteData(String url) async {
  final target = Uri.parse(url);
  final response = await http.get(target);
  if (response.statusCode != 200) {
    throw Exception('ERROR: ${response.statusCode}');
  }
  return response.bodyBytes.buffer.asByteData();
}

Future<String> fetchHttpString(String url) async {
  final target = Uri.parse(url);
  final response = await http.get(target);
  if (response.statusCode != 200) {
    throw Exception('ERROR: ${response.statusCode}');
  }
  return response.body;
}

Future<String?> getOGPImageUrl(String url) async {
  final data = await OgpDataExtract.execute(url);
  final meta = await MetadataFetch.extract(url);
  if (data == null || meta == null) {
    return parseImageThumbnail(parse(await fetchHttpString(url)));
  } else {
    return data.image ?? meta.image;
  }
}

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
