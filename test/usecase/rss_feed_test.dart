import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'feed parse test',
    () async {
      final webRepo = WebRepoImpl();
      final usecase = RssFeedUsecase(webRepo: webRepo);
      const uri = 'https://iphone-mania.jp';
      final res = await usecase.parseRss(uri);
      expect(res, isNotNull);
      expect(res!.feeds.length, isNonZero);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test(
    'RssFeed Parse',
    () async {
      final webRepo = WebRepoImpl();
      final usecase = RssFeedUsecase(webRepo: webRepo);
      const path = 'https://iphone-mania.jp/feed/';
      final data = await usecase.convertFeedLinkToRssItems(path);
      expect(data.length, isNonZero);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
