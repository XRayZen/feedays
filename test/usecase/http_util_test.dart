import 'package:feedays/domain/Util/http_parse.dart';
import 'package:feedays/domain/web/http_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ogpImage', () async {
    //BUG:ogpが読み込めない->httpsじゃないとmetaを読み込めない->タグを探してイメージリンクを
    final path = 'http://jin115.com/archives/52365485.html';
    'https://gigazine.net/news/20230222-youtube-infinite-file-storage/';
    // 'https://www.kamo-it.org/blog/web_feed/';
    // 'http://jin115.com/archives/52365492.html';
    final response = await getHttpString(path);
    final data = await getOGPImageUrl(path);
    expect(data, isNotNull);
  });
}
