import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/services.dart';

Future<List<Article>> genFakeRssFeeds(int num,) async {
  final fakeFeeds = <Article>[];
  for (var i = 0; i < num; i++) {
    fakeFeeds.add(
      Article(
        index: i,
        title: 'Fake Site:$i.com fake:{$i} ',
        description: 'Description:$i',
        link: 'none',
        image: RssFeedImage(
          link: 'assets/confused-face.png',
          image: await getAssetData('assets/confused-face.png'),
        ),
        site: 'none',
        category: 'Fake',
        lastModified: DateTime.now(), 
        siteUrl: 'none',
      ),
    );
  }
  return fakeFeeds;
}

Future<ByteData> getAssetData(String key) async {
  final data = await rootBundle.load(key);
  return data;
}
