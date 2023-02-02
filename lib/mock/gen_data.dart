import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';

List<RssFeed> genFakeRssFeeds(int num) {
  var fakeFeeds = <RssFeed>[];
  for (var i = 0; i < num; i++) {
    fakeFeeds.add(RssFeed(
        title: "Fake Site:$i",
        description: "Description:$i",
        link: "none",
        image: ByteData(0),
        site: "none",
        category: "Fake"
        ));
  }
  return fakeFeeds;
}

