import 'package:feedays/domain/entities/web_sites.dart';
import 'package:webfeed/webfeed.dart';

List<RssFeedItem> rssFeedConvert(RssFeed rssFeed) {
  final items = List<RssFeedItem>.empty(growable: true);
  if (rssFeed.items != null && rssFeed.items!.isNotEmpty) {
    var index = 0;
    for (final item in rssFeed.items!) {
      var imageLink = '';
      if (item.content != null && item.content!.images.isNotEmpty) {
        imageLink = item.content!.images.first;
      }
      items.add(
        RssFeedItem(
          index: index,
          title: item.title ?? '',
          description: item.description ?? '',
          link: item.link ?? '',
          image: RssFeedImage(link: imageLink, image: null),
          site: rssFeed.title ?? '',
          category: rssFeed.dc?.subject ?? '',
          lastModified:
              item.pubDate ?? item.dc?.date ?? DateTime.utc(2000, 1, 1, 1, 1),
        ),
      );
      index++;
    }
  }
  return items;
}
