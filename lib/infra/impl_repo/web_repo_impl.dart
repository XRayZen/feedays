import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import 'package:webfeed/webfeed.dart';

class WebRepoImpl extends WebRepositoryInterface {
  @override
  Future<WebSite> getFeeds(WebSite site) {
    // TODO: implement getFeeds
    throw UnimplementedError();
  }

  @override
  Future<bool> anyPath(String path) async {
    final target = Uri.parse(path);
    // final response = await http.get(target);
    final response = await Dio().getUri(target);
    if (response.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<WebSite> fetchSiteOgpMeta(String url) async {
    //これらの関数はポンコツすぎてほとんど使い物にならないから
    //TODO:utilにサイトメタを分析する関数を手動で実装する
    //明示的にUTF-8に変換を行うことで文字化けに対応
    try {
      final data = await fetchHttpByte(url);
      // final toUtf8 = const Utf8Decoder().convert(data);
      // final webSiteDoc = parse(await fetchHttpString(url, isUtf8: true));
      final toUtf8 = utf8.decode(data);
      final webSiteDoc = parse(toUtf8);
      return parseDocumentToWebSite(
        url,
        webSiteDoc,
      );
    } on Exception catch (e) {
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
      // 以降のフローはRSS取得不要
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
      return rssWebMeta;
    }
  }

  @override
  Future<Uint8List> fetchHttpByte(String url) async {
    final target = Uri.parse(url);
    // https://github.com/cfug/dio/blob/main/example/lib/download.dart
    // final response = await http.get(target);
    final response = await Dio().getUri<Uint8List>(
      target,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(seconds: 50),
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    return response.data!;
  }

  @override
  Future<String> fetchHttpString(String url, {bool isUtf8 = false}) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    if (isUtf8) {
      return utf8.decode(response.bodyBytes.buffer.asUint8List());
    } else {
      return response.body;
    }
  }

  @override
  Future<String?> getOGPImageUrl(String url) async {
    final data = await OgpDataExtract.execute(url);
    final meta = await MetadataFetch.extract(url);
    if (data == null || meta == null) {
      return parseImageThumbnail(
        parse(
          await fetchHttpString(url),
        ),
      );
    } else {
      return data.image ?? meta.image;
    }
  }
}
