import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';

List<RssFeed> genFakeRssFeeds(int num, {int start = 0}) {
  var fakeFeeds = <RssFeed>[];
  for (var i = 0; i < num; i++) {
    fakeFeeds.add(RssFeed(
        index: start,
        title: "Fake Site:$start",
        description: "Description:$start",
        link: "none",
        image: ByteData(0),
        site: "none",
        category: "Fake"));
    start++;
  }
  return fakeFeeds;
}
