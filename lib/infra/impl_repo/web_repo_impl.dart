// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/infra/datasources/http_parse.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import 'package:webfeed/webfeed.dart';

class WebRepoImpl extends WebRepositoryInterface {
  @override
  Future<WebSite> getFeeds(
    String url, {
    void Function(int count, int all, String msg)? progressCallBack,
  }) async {
    //インフラ層ではRepo->サイトURLでメタ・RSSを取得変換して例外有りで返す
    final meta = await fetchSiteOgpMeta(url);
    // 取得済みなら変換して返す
    if (meta.feeds.isNotEmpty) {
      meta.feeds = await parseImageLink(
        this,
        meta.feeds,
        progressCallBack: progressCallBack,
      );
      return meta;
    }
    final rssFeed = await getRssFeed(this, url);
    if (rssFeed == null) {
      throw Exception('Not Found Rss URL: $url');
    }
    return WebSite(
      key: rssFeed.siteLink,
      name: rssFeed.title,
      siteUrl: rssFeed.siteLink,
      siteName: meta.siteName,
      iconLink: rssFeed.iconLink ?? meta.iconLink,
      rssUrl: rssFeed.feedLink,
      tags: [],
      feeds: await parseImageLink(
        this,
        rssFeed.items,
        progressCallBack: progressCallBack,
      ),
      description: rssFeed.description,
      lastModified: DateTime.now().toLocal(),
    );
  }

  @override
  Future<WebSite> refreshRss(
    WebSite site, {
    void Function(int count, int all, String msg)? progressCallBack,
  }) async {
    //RSS取得変換して既存を比較して新しいのをカウントインサートして例外有りで返す
    final res = await refreshRssConvert(this, site);
    if (res == null) {
      throw Exception('ERROR Refresh Rss');
    } else {
      return res;
    }
  }

  @override
  Future<bool> anyPath(String path) async {
    final target = Uri.parse(path);
    try {
      final response = await http.get(target);
      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  @override
  Future<WebSite> fetchSiteOgpMeta(String url) async {
    //これらの関数はポンコツすぎてほとんど使い物にならないから
    //utilにサイトメタを分析する関数を手動で実装する
    //明示的にUTF-8に変換を行うことで文字化けに対応
    try {
      final data = await fetchHttpByte(url);
      final toUtf8 = utf8.decode(data);
      final webSiteDoc = parse(toUtf8);
      return parseDocumentToWebSite(
        url,
        webSiteDoc,
      );
    } on Exception catch (_) {
      //utf8に変換出来ないサイトなら
      //documentベースのメタを取得して次にRSSを取得してメタを再構成する
      //RSSを取得しているからRss_UtilでRssFeedからFeedListを生成して処理が無駄になるのを防ぐ
      final data = await fetchHttpString(url);
      //変換できないサイトはどんな方法でも必ず文字化けするからこれでいい
      final rawDoc = parse(data);
      final docMeta = parseDocumentToWebSite(
        url,
        rawDoc,
      );
      //次にRSSを取得してWebMetaを補完する
      final rssLink = extractRSSLinkFromWebsite(
        docMeta.siteName,
        rawDoc,
        RSSorAtom.rss,
      );
      final rssData = await http.get(Uri.parse(rssLink));
      final rssFeed =
          RssFeed.parse(utf8.decode(rssData.bodyBytes.buffer.asUint8List()));
      final rssWebMeta = await parseRssToWebSiteMeta(
        url,
        docMeta,
        rssFeed,
      );
      // 以降のフローはRSS取得不要
      return rssWebMeta;
    }
  }

  @override
  Future<Uint8List> fetchHttpByte(String url) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    return response.bodyBytes;
  }

  @override
  Future<String> fetchHttpString(String url, {bool isUtf8 = false}) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    if (isUtf8) {
      try {
        return utf8.decode(response.bodyBytes.buffer.asUint8List());
      } on Exception catch (_) {
        return response.body;
      }
    } else {
      try {
        return response.body;
      } catch (e) {
        return utf8.decode(
          response.bodyBytes.buffer.asUint8List(),
          allowMalformed: true,
        );
      }
    }
  }

  @override
  Future<String?> getOGPImageUrl(String url) async {
    try {
      final data = await OgpDataExtract.execute(url);
      final meta = await MetadataFetch.extract(url);
      if (data == null || meta == null) {
        try {
          return parseImageThumbnail(
            parse(
              await fetchHttpString(url, isUtf8: true),
            ),
          );
        } on Exception catch (_) {
          final doc = await fetchHttpString(url);
          return parseImageThumbnail(parse(doc));
        }
      } else {
        return data.image ?? meta.image;
      }
    } catch (_) {
      try {
        final doc = await fetchHttpString(url);
        return parseImageThumbnail(parse(doc));
      } catch (_) {
        return null;
      }
    }
  }
}
