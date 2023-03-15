import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/foundation.dart';

List<FeedItem> genFakeRssFeeds(int num) {
  final feeds = List<FeedItem>.empty(growable: true);
  for (var i = 0; i < num; i++) {
    feeds.add(
      FeedItem(
        index: i,
        title: 'fake:{$i}',
        description: 'fake description',
        link:
            'https://wired.jp/article/fast-forward-the-chatbot-search-wars-have-begun/',
        image: RssFeedImage(
          link: 'assets/confused-face.png',
          image: ByteData(0),
        ),
        site: 'fakeSite:{$i}',
        category: 'MockedCategory',
        lastModified: DateTime.now(),
      ),
    );
  }
  return feeds;
}
