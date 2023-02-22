// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:html/dom.dart';

// https://zenn.dev/tris/articles/9705b93a02425f

String parseImageThumbnail(Document doc) {
  // ヘッダー内のtitleタグの中身を取得
  // final title = doc.head!.getElementsByTagName('title')[0].innerHtml;
  // ignore: unused_local_variable
  String _description;
  var imageLink = '';
// ヘッダー内のmetaタグをすべて取得
  final metas = doc.head!.getElementsByTagName('meta');

  for (final meta in metas) {
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
