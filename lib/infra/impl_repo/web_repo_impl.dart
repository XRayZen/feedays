import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

class WebRepoImpl extends WebRepositoryInterface {
  @override
  Future<WebSite> getFeeds(WebSite site) {
    // TODO: implement getFeeds
    throw UnimplementedError();
  }

  @override
  Future<bool> anyPath(String path) async {
    final target = Uri.parse(path);
    final response = await http.get(target);
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
      return parseDocumentToWebSite(
        url,
        parse(await fetchHttpString(url, true)),
      );
    } on Exception catch (e) {
      //utf8に変換出来ないサイトなら
      //documentベースのメタを取得して次にRSSを取得してメタを再構成する
      //RSSを取得しているからRss_UtilでRssFeedからFeedListを生成して処理が無駄になるのを防ぐ
      final doc = parse(await fetchHttpString(url, true));
      final docMeta = parseDocumentToWebSite(
        url,
        doc,
      );
      //
    }
  }

  @override
  Future<ByteData> fetchHttpByteData(String url) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    return response.bodyBytes.buffer.asByteData();
  }

  @override
  Future<String> fetchHttpString(String url, bool isRaw) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    if (isRaw) {
      return response.body;
    } else {
      //4Gamerなどの一部サイトはこれでエラーが出るからサイトメタの構成が困難になる
      return const Utf8Decoder().convert(response.bodyBytes);
    }
  }

  @override
  Future<String?> getOGPImageUrl(String url) async {
    final data = await OgpDataExtract.execute(url);
    final meta = await MetadataFetch.extract(url);
    if (data == null || meta == null) {
      return parseImageThumbnail(parse(await fetchHttpString(url, true)));
    } else {
      return data.image ?? meta.image;
    }
  }
}
