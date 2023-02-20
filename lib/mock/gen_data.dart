
import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<List<RssFeed>> genFakeRssFeeds(int num, {int start = 0})async {
  final fakeFeeds = <RssFeed>[];
  for (var i = 0; i < num; i++) {
    fakeFeeds.add(
      RssFeed(
        index: start,
        title: 'Fake Site:$start fake:{$i} ',
        description: 'Description:$start',
        link: 'none',
        image:await getAssetData('assets/confused-face.png'),
        site: 'none',
        category: 'Fake',
        lastModified: DateTime.now(),
      ),
    );
    start++;
  }
  return fakeFeeds;
}

Future<ByteData> getAssetData(String key) async {
  final data = await rootBundle.load(key);
  return data;
}
