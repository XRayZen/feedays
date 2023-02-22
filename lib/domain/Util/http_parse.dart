// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:feedays/domain/web/http_util.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';

// https://zenn.dev/tris/articles/9705b93a02425f

Future<Document> httpLoadDoc(
  String url,
) async {
  final response = await getHttpString(url);
  return parse(response);
}

String parseImageThumbnail(Document doc) {
  // ヘッダー内のtitleタグの中身を取得
  // final title = doc.head!.getElementsByTagName('title')[0].innerHtml;
  String _description;
  var imageLink = '';
// ヘッダー内のmetaタグをすべて取得
  var metas = doc.head!.getElementsByTagName('meta');

  for (var meta in metas) {
    // metaタグの中からname属性がdescriptionであるものを探す
    if (meta.attributes['name'] == 'description') {
      _description = meta.attributes['content'] ?? '';
      // metaタグの中からproperty属性がog:imageであるものを探す
    } else if (meta.attributes['property'] == 'og:image') {
      imageLink = meta.attributes['content']!;
    }
  }
  return imageLink;
}

Future<String?> getOGPImageUrl(String url) async {
  final data = await OgpDataExtract.execute(url);
  final meta = await MetadataFetch.extract(url);
  if (data == null || meta == null) {
    return parseImageThumbnail(await httpLoadDoc(url));
  }else{
    return data.image ?? meta.image;
  }
}
