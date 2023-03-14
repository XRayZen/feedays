
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get WebSite', () async {
    //4GamerのサイトをメタとRSSFeedを含んだ完全なWebSiteを取得する
    final webRepo = WebRepoImpl();
    final usecase = RssFeedUsecase(webRepo: webRepo);
    //サイトのURLを渡してからサイトのメタを構成してから
    const Url = 'https://www.4gamer.net/';
    
    final res = await usecase.fetchRss(
      Url,
      progressCallBack: showDownloadProgress,
    );
    // TODO:取得フローが複雑過ぎたのでリファクタリングする
    expect(res.feeds, isNotEmpty);
  },
  timeout: const Timeout(Duration(minutes: 6)),
  );
}
