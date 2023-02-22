

import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ogpImage', () async {
    //BUG:ogpが読み込めない->httpsじゃないとmetaを読み込めない->タグを探してイメージリンクを
    final path = 'http://jin115.com/archives/52365485.html';
    'https://gigazine.net/news/20230222-youtube-infinite-file-storage/';
    // 'https://www.kamo-it.org/blog/web_feed/';
    // 'http://jin115.com/archives/52365492.html';
    final webrepo = WebRepoImpl();
    final response = await webrepo.fetchHttpString(path);
    final data = await webrepo.getOGPImageUrl(path);
    expect(data, isNotNull);
  });
}
