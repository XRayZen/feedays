import 'dart:convert';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';

void main() {
  test(
    'feed parse test',
    () async {
      final webRepo = WebRepoImpl();
      final usecase = RssFeedUsecase(webRepo: webRepo);
      const uri = 'http://jin115.com/';
      final res = await usecase.fetchRss(uri);
      expect(res, isNotNull);
      expect(res.feeds.length, isNonZero);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test(
    'RssFeed Parse',
    () async {
      final webRepo = WebRepoImpl();
      final usecase = RssFeedUsecase(webRepo: webRepo);
      const path = 'https://iphone-mania.jp/feed/';
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test('RssLink Parse', () async {
    //スクレイピングの領域
    //サイトHTMLからRSSLinkを抽出
    const url = 'https://kabumatome.doorblog.jp/';
    final target = Uri.parse(url);
    final response = await http.get(target);
    final res = extractRSSLinkFromWebsite(
        '市況かぶ全力２階建', parse(response.body), RSSorAtom.rss);
    expect(res, 'https://kabumatome.doorblog.jp/index.rdf');
  });
  test('WebSite Meta Parse', () async {
    //メタタグを解析してサイトメタを読み取る
    const url = 'https://www.4gamer.net/';
    final target = Uri.parse(url);
    final response = await http.get(target);
    final res = parseDocumentToWebSite(url, parse(response.body));
    expect(res.siteName, '4Gamer.net');
  });
  test('Rss To WebSiteMeta', () async {
    //サイトメタをRSSからも取得する
    const url = 'https://www.4gamer.net/';
    final target = Uri.parse(url);
    final response = await http.get(target);
    final docWebMeta = parseDocumentToWebSite(url, parse(response.body));
    expect(docWebMeta.siteName, '4Gamer.net');
    //RSSURLを取得
    final rssLink = extractRSSLinkFromWebsite(
      docWebMeta.siteName,
      parse(response.body),
      RSSorAtom.rss,
    );
    print(rssLink);
    final rssData = await http.get(Uri.parse(rssLink));
    final rssFeed =
        RssFeed.parse(utf8.decode(rssData.bodyBytes.buffer.asUint8List()));
    expect(rssFeed.items, isNotEmpty);
    //TODO:RSSを取得出来たから後はサイトメタを構成する
    final RssWebMeta =await parseRssToWebSiteMeta(
      url,
      docWebMeta,
      rssFeed,
    );
    print(RssWebMeta.description);
    // expect(
    //   RssWebMeta.description,
    // );
  });
}
