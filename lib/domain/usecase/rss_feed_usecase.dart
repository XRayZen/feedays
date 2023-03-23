// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_catches_without_on_clauses

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/infra/datasources/http_parse.dart';
import 'package:feedays/infra/datasources/rss_util.dart';
import 'package:html/parser.dart' show parse;

class RssFeedUsecase {
  final WebRepositoryInterface webRepo;
  RssFeedUsecase({
    required this.webRepo,
  });

  // ///RSSを更新する
  // Future<WebSite?> refreshRss(WebSite site) async {
  //   //新規サイトを取得
  //   if (site.rssUrl.isEmpty) {
  //     final res = await fetchRss(site.siteUrl);
  //     res.newCount = res.feeds.length;
  //     return res;
  //   }
  //   //既存サイトを更新する
  //   final newFeedItems =
  //       await fetchRss(site.siteUrl).then((value) => value.feeds);
  //   if (site.feeds.isEmpty) {
  //     site.feeds.addAll(newFeedItems);
  //     site.newCount = newFeedItems.length;
  //     return site;
  //   }
  //   //既存と比べて新しいフィードをカウントする
  //   site.newCount = 0;
  //   // ignore: omit_local_variable_types, prefer_final_locals
  //   List<FeedItem> newItems = <FeedItem>[];
  //   for (final newItem in newFeedItems) {
  //     if (site.feeds.any(
  //       (x) =>
  //           x.lastModified.millisecondsSinceEpoch <
  //           newItem.lastModified.millisecondsSinceEpoch,
  //     )) {
  //       //でもURLが同じなのは入れない
  //       if (!site.feeds.any((x) => x.link == newItem.link)) {
  //         site.newCount++;
  //         newItems.add(newItem);
  //       }
  //     }
  //   }
  //   //カウントしたら新しいのをインサートする
  //   site.feeds.addAll(newItems);
  //   return site;
  // }

  // ///有効なRSSFeedを返す
  // Future<FeedObject?> getRssFeed(String url) async {
  //   if (await webRepo.anyPath(url)) {
  //     try {
  //       final data = await webRepo.fetchHttpByte(url);
  //       final rss = rssDataToRssObj(data, url);
  //       if (rss != null && rss.items.isNotEmpty) {
  //         return rss;
  //       }
  //     } catch (_) {
  //       //RSSではないのならRSS抽出処理を継続する
  //     }
  //   }
  //   //サイトHTMLからRSSLinkを抽出する
  //   //もしUTF8変換エラーならRawにして先にRSSFeedを取得してサイトメタを構成する
  //   var data = '';
  //   try {
  //     data = await webRepo.fetchHttpString(url, isUtf8: true);
  //   } on Exception catch (_) {
  //     //4Gamerなどの一部２バイト文字サイトはutf8変換出来ないからRSSからMetaを生成するしかない
  //     //flutterのhttp系パッケージは２バイト文字サイトにはほとんど使い物にならないゴミとなる
  //     data = await webRepo.fetchHttpString(url);
  //     final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
  //     final rssUrl = extractRSSLinkFromWebsite(
  //       docBaseSiteMeta.siteName,
  //       parse(data),
  //       RSSorAtom.rss,
  //     );
  //     //FullPathの場合
  //     if (await webRepo.anyPath(url + rssUrl)) {
  //       final rssData = await webRepo.fetchHttpByte(url + rssUrl);
  //       return rssDataToRssObj(rssData, rssUrl);
  //     }
  //     //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
  //     else if (await webRepo.anyPath(rssUrl)) {
  //       final rssData = await webRepo.fetchHttpByte(rssUrl);
  //       return rssDataToRssObj(rssData, rssUrl);
  //     }
  //   }
  //   final docBaseSiteMeta = parseDocumentToWebSite(url, parse(data));
  //   var rssUrl = '';
  //   try {
  //     rssUrl = extractRSSLinkFromWebsite(
  //       docBaseSiteMeta.siteName,
  //       parse(data),
  //       RSSorAtom.rss,
  //     );
  //   } on Exception catch (_) {
  //     rssUrl = extractRSSLinkFromWebsite(
  //       docBaseSiteMeta.siteName,
  //       parse(data),
  //       RSSorAtom.atom,
  //     );
  //   }
  //   //中にはhrefに中途半端なURLを渡すのもいる "/feed.xml
  //   if (!rssUrl.contains('://')) {
  //     final rssData = await webRepo.fetchHttpByte(url + rssUrl);
  //     return rssDataToRssObj(rssData, rssUrl);
  //   }
  //   final rssData = await webRepo.fetchHttpByte(rssUrl);
  //   return rssDataToRssObj(rssData, rssUrl);
  // }

  // Future<WebSite> fetchRss(
  //   String siteUrl, {
  //   void Function(int count, int all, String msg)? progressCallBack,
  // }) async {
  //   final meta = await webRepo.fetchSiteOgpMeta(siteUrl);
  //   // 取得済みなら変換して返す
  //   if (meta.feeds.isNotEmpty) {
  //     meta.feeds = await parseImageLink(
  //       webRepo,
  //       meta.feeds,
  //       progressCallBack: progressCallBack,
  //     );
  //     return meta;
  //   }
  //   final rssFeed = await getRssFeed(siteUrl);
  //   if (rssFeed == null) {
  //     throw Exception('Not Found Rss URL: $siteUrl');
  //   }
  //   return WebSite(
  //     key: rssFeed.link,
  //     name: rssFeed.title,
  //     siteUrl: meta.siteUrl,
  //     siteName: meta.siteName,
  //     iconLink: meta.iconLink,
  //     rssUrl: rssFeed.link,
  //     tags: [],
  //     feeds: await parseImageLink(
  //       webRepo,
  //       rssFeed.items,
  //       progressCallBack: progressCallBack,
  //     ),
  //     description: rssFeed.description,
  //   );
  // }
}
