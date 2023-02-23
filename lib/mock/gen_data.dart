
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/services.dart';

Future<List<RssFeedItem>> genFakeRssFeeds(int num, {int start = 0}) async {
  final fakeFeeds = <RssFeedItem>[];
  for (var i = 0; i < num; i++) {
    fakeFeeds.add(
      RssFeedItem(
        index: start,
        title: 'Fake Site:$start fake:{$i} ',
        description: 'Description:$start',
        link: 'none',
        image: RssFeedImage(
          link: 'assets/confused-face.png',
          image: await getAssetData('assets/confused-face.png'),
        ),
        site: 'none',
        category: 'Fake',
        lastModified: DateTime.now(),
      ),
    );
    start++;
  }
  return fakeFeeds;
}

void genFakeSites() {
  //偽サイトを生成
}

Future<ByteData> getAssetData(String key) async {
  final data = await rootBundle.load(key);
  return data;
}
