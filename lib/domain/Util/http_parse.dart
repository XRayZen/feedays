// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:feedays/domain/Util/rss_util.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:html/dom.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

// https://zenn.dev/tris/articles/9705b93a02425f

String parseImageThumbnail(Document doc) {
  // ヘッダー内のtitleタグの中身を取得
  // ignore: unused_local_variable
  String _description;
  var imageLink = '';
// ヘッダー内のmetaタグをすべて取得
  final metas = doc.head!.getElementsByTagName('meta');

  for (final meta in metas) {
    // metaタグの中からname属性がdescriptionであるものを探す
    if (meta.attributes['name'] == 'description') {
      _description = meta.attributes['content'] ?? '';
      // metaタグの中からproperty属性がog:imageであるものを探す
    } else if (meta.attributes['property'] == 'og:image') {
      imageLink = meta.attributes['content']!;
    }
  }
  return imageLink;
}

enum RSSorAtom { rss, atom }

String extractRSSLinkFromWebsite(
  String siteName,
  Document doc,
  RSSorAtom rssType,
) {
  final links = doc.head!.getElementsByTagName('link');
  if (links.any((e) => e.attributes.containsKey('title'))) {
    final titles = links
        .where((element) => element.attributes.containsKey('title'))
        .toList();
    final maps = <String, String>{};
    for (final e in titles) {
      //titleキーにRSSかAtomという
      //hrefキーにURL
      final titleKey = e.attributes.entries
          .map((el) {
            if (el.key == 'title') {
              return el.value;
            }
          })
          .whereType<String>()
          .first;
      final rssURL = e.attributes.entries
          .map((el) {
            if (el.key == 'href') {
              return el.value;
            }
          })
          .whereType<String>()
          .first;
      maps.addAll({titleKey: rssURL});
    }
    if (maps.containsKey(siteName)) {
      return maps.entries.first.value;
    }
    switch (rssType) {
      case RSSorAtom.rss:
        {
          if (maps.containsKey('RSS') ||
              maps.containsKey('RSS2.0') ||
              maps.containsKey('RSS1.0')) {
            return maps.entries
                .where((element) => element.key == 'RSS')
                .first
                .value;
          }
          return maps.entries.first.value;
        }
      case RSSorAtom.atom:
        if (maps.containsKey('Atom')) {
          return maps.entries
              .where((element) => element.key == 'Atom')
              .first
              .value;
        }
        return maps.entries.first.value;
    }
  } else {
    throw Exception('Invalid RSS Site');
  }
}

///メタタグを解析してサイトメタを読み取る
WebSite parseDocumentToWebSite(
  String siteUrl,
  Document doc,
) {
  final maps = <String, String>{};
  //BUG:２バイト文字が文字化けしてしまう-> utf8で変換してみるが無駄か
  final metas = doc.head!.getElementsByTagName('meta');
  for (final meta in metas) {
    if (meta.attributes['property'] == 'og:site_name') {
      maps.addAll({'SiteName': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:title') {
      maps.addAll({'Title': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:type') {
      maps.addAll({'type': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:url') {
      maps.addAll({'SiteUrl': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:description') {
      maps.addAll({'description': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:image') {
      maps.addAll({'Image': meta.attributes['content'] ?? ''});
    } else if (meta.attributes['property'] == 'og:keywords') {
      maps.addAll({'Keywords': meta.attributes['content'] ?? ''});
    }
  }
  final tag = maps['SiteUrl'];
  //BUG:ここでバグが出ている
  return WebSite(
    key: maps['SiteUrl'] ?? siteUrl,
    name: maps['Title'] ?? '',
    siteUrl: maps['SiteUrl'] ?? siteUrl,
    siteName: maps['SiteName'] ?? '',
    iconLink: maps['Image'] ?? '',
    category: maps['type'] ?? '',
    tags: tag != null ? [tag] : [],
    feeds: [],
    description: maps['description'] ?? '',
  );
}

Future<WebSite> parseRssToWebSiteMeta(
  String url,
  WebSite meta,
  RssFeed feed,
) async {
  return WebSite(
    key: feed.link ?? '',
    name: meta.siteName,
    siteUrl: feed.link ?? url,
    siteName: meta.siteName,
    iconLink: meta.iconLink,
    category: meta.category,
    tags: feed.itunes?.keywords ?? [],
    feeds: rssFeedConvert(feed),
    description: feed.description ?? '',
  );
}
