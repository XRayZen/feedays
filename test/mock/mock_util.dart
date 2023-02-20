

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

List<RssFeed> genFakeRssFeeds(int num) {
  final feeds = List<RssFeed>.empty(growable: true);
  for (var i = 0; i < num; i++) {
    feeds.add(
      RssFeed(
        index: i,
        title: 'fake:{$i}',
        description: 'fake description',
        link:
            'https://wired.jp/article/fast-forward-the-chatbot-search-wars-have-begun/',
        image: ByteData(0),
        site: 'fakeSite:{$i}',
        category: 'MockedCategory',
        lastModified: DateTime.now(),
      ),
    );
  }
  return feeds;
}
