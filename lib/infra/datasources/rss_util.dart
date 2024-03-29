import 'dart:convert';
import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:webfeed/webfeed.dart';

FeedObject? feedDataToRssObj(Uint8List data, String url) {
  try {
    final rss = RssFeed.parse(utf8.decode(data.buffer.asUint8List()));
    if (rss.items != null) {
      return convertRssToFeedObj(rss, url);
    }
    // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
  } catch (_) {
    final atom = AtomFeed.parse(utf8.decode(data.buffer.asUint8List()));
    if (atom.items != null) {
      return convertAtomToFeedObj(atom, url);
    }
  }
  return null;
}

List<Article> rssFeedConvert(RssFeed rssFeed) {
  final items = List<Article>.empty(growable: true);
  if (rssFeed.items != null && rssFeed.items!.isNotEmpty) {
    var index = 0;
    for (final item in rssFeed.items!) {
      var imageLink = '';
      if (item.content != null && item.content!.images.isNotEmpty) {
        imageLink = item.content!.images.first;
      }
      final feedItem = Article(
        index: index,
        title: item.title ?? '',
        description: item.description ?? '',
        link: item.link ?? '',
        image: RssFeedImage(link: imageLink, image: null),
        site: rssFeed.title ?? '',
        category: rssFeed.dc?.subject ?? '',
        lastModified:
            item.pubDate ?? item.dc?.date ?? DateTime.utc(2000, 1, 1, 1, 1),
      );
      //記事の日時をローカルに書き換える
      feedItem.lastModified = feedItem.lastModified.toLocal();
      items.add(feedItem);
      index++;
    }
  }
  return items;
}

List<Article> atomFeedConvert(AtomFeed atomFeed) {
  final items = List<Article>.empty(growable: true);
  if (atomFeed.items != null && atomFeed.items!.isNotEmpty) {
    var index = 0;
    for (final item in atomFeed.items!) {
      var imageLink = '';
      if (item.media != null &&
          item.media!.thumbnails != null &&
          item.media!.thumbnails!.isNotEmpty) {
        imageLink = item.media!.thumbnails!.first.url ?? '';
      }
      var link = '';
      if (item.links != null && item.links!.isNotEmpty) {
        try {
          link = item.links!
                  .where((element) => element.rel == 'alternate')
                  .first
                  .href ??
              '';
          imageLink = item.links!
                  .where(
                    (element) =>
                        element.type == 'image/png' ||
                        element.type == 'image/jpeg',
                  )
                  .first
                  .href ??
              '';
          // ignore: avoid_catches_without_on_clauses
        } catch (_) {}
      }
      var cate = '';
      if (item.categories != null && item.categories!.isNotEmpty) {
        cate = item.categories!.first.label ?? '';
      }
      final feedItem = Article(
        index: index,
        title: item.title ?? '',
        description: item.summary ?? '',
        link: link,
        image: RssFeedImage(link: imageLink, image: null),
        site: atomFeed.title ?? '',
        category: cate,
        lastModified: item.updated ?? DateTime.utc(2000, 1, 1, 1, 1),
      );
      //記事の日時をローカルに書き換える
      feedItem.lastModified = feedItem.lastModified.toLocal();
      items.add(feedItem);
      index++;
    }
  }
  return items;
}

FeedObject convertRssToFeedObj(RssFeed rssFeed, String feedUrl) {
  return FeedObject(
    items: rssFeedConvert(rssFeed),
    title: rssFeed.title ?? '',
    siteLink: rssFeed.link ?? '',
    feedLink: feedUrl,
    description: rssFeed.description ?? '',
    category: rssFeed.dc?.subject ?? '',
    iconLink: rssFeed.image?.url,
  );
}

FeedObject convertAtomToFeedObj(AtomFeed atomFeed, String url) {
  return FeedObject(
    items: atomFeedConvert(atomFeed),
    title: atomFeed.title ?? '',
    siteLink: url,
    feedLink: url,
    description: atomFeed.subtitle ?? '',
    category: '',
    iconLink: atomFeed.icon ?? atomFeed.logo,
  );
}
