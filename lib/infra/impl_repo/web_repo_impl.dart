import 'dart:typed_data';

import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

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
    final data = await OgpDataExtract.execute(url);
    final meta = await MetadataFetch.extract(url);
    if (data != null) {
      return WebSite(
        //とりあえずkeyをurlにしておく
        key: url,
        name: data.siteName ?? '',
        url: data.url ?? '',
        feeds: [],
        category: '',
        fav: false,
        newCount: 0,
        readLateCount: 0,
        tags: [],
        iconLink: data.image ?? data.imageSecureUrl ?? '',
        description: data.description ?? '',
      );
    } else if (meta != null) {
      return WebSite(
        //とりあえずkeyをurlにしておく
        key: url,
        name: meta.title ?? '',
        url: meta.url ?? '',
        feeds: [],
        category: '',
        fav: false,
        newCount: 0,
        readLateCount: 0,
        tags: [],
        iconLink: meta.image ?? '',
        description: meta.description ?? '',
      );
    }
    return WebSite(
        //とりあえずkeyをurlにしておく
        key: url,
        name:  '',
        url: url ,
        feeds: [],
        category: '',
        fav: false,
        newCount: 0,
        readLateCount: 0,
        tags: [],
        iconLink:  '',
        description:  '',
      );
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
  Future<String> fetchHttpString(String url) async {
    final target = Uri.parse(url);
    final response = await http.get(target);
    if (response.statusCode != 200) {
      throw Exception('ERROR: ${response.statusCode}');
    }
    return response.body;
  }

  @override
  Future<String?> getOGPImageUrl(String url) async {
    final data = await OgpDataExtract.execute(url);
    final meta = await MetadataFetch.extract(url);
    if (data == null || meta == null) {
      return parseImageThumbnail(parse(await fetchHttpString(url)));
    } else {
      return data.image ?? meta.image;
    }
  }
}
