import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/foundation.dart';

import 'gen_data.dart';

Future<List<RssFeedItem>> genFakeRssFeeds(int num, String word) async {
  final feeds = List<RssFeedItem>.empty(growable: true);
  for (var i = 0; i < num; i++) {
    feeds.add(
      RssFeedItem(
        index: i,
        title: 'fake:{$i} key:{$word}',
        description: 'fake description',
        link:
            'https://wired.jp/article/fast-forward-the-chatbot-search-wars-have-begun/',
        image: RssFeedImage(
          link: 'assets/confused-face.png',
          image: await getAssetData('assets/confused-face.png'),
        ),
        site: 'fakeSite:{$i}',
        category: 'MockedCategory',
        lastModified: DateTime.now(),
      ),
    );
  }
  return feeds;
}
