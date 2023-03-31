// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/search/list_item/rss_feed_item_ui.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/indicator/error_indicator.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteRssFeedList extends ConsumerWidget {
  final WebSite site;
  const SiteRssFeedList({
    super.key,
    required this.site,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //リトライ処理で処理が終わったらここから再描画させる
    final retry = ref.watch(reTryRssFeedProvider);
    //リトライプロバイダーのステートが初期状態ならリトライ処理されていない
    if (retry.key != '' && retry.siteUrl == site.siteUrl) {
      //リトライ処理での結果を反映
      return _buildList(context, retry.feeds, ref);
    } else {
      //データを読み込む
      final readSiteResponse = ref.watch(readWebSiteProvider(site));
      return readSiteResponse.when(
        data: (response) {
          return _buildList(context, response.feeds, ref);
        },
        error: (error, stackTrace) {
          //エラーで既存があるのなら表示する
          final res = ref
              .watch(rssUsecaseProvider)
              .userCfg
              .rssFeedSites
              .searchSiteFeedList(site.siteUrl);
          if (res != null) {
            return _buildList(context, res, ref);
          }
          return ErrorIndicator(
            error: error,
            //再描画するだけでフィード取得処理が走るから問題ないか
            onTryAgain: () async {
              //今はリトライ処理はサイト選択プロバイダーで入れたほうが良いか
              //しかし、それより、サイト選択プロバイダー監視の前に一つRetryProviderを設置して
              //変化したら再描画させてリトライ処理を実現させる
              await ref
                  .watch(reTryRssFeedProvider.notifier)
                  .retry(context, site);
            },
          );
        },
        loading: () {
          return const CircularProgressIndicator();
        },
      );
    }
  }

  Widget _buildList(
    BuildContext context,
    List<FeedItem> feeds,
    WidgetRef ref,
  ) {
    final modelList = convertViewModel(feeds);
    return RefreshIndicator(
      onRefresh: () async {
        //リトライNotifierでリトライ処理して出来たらstateに入れてリストWidgetを更新
        await ref.watch(reTryRssFeedProvider.notifier).retry(context, site);
      },
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildListItem(modelList, index, feeds);
              },
              childCount: modelList.length,
            ),
          ),
        ],
      ),
    );
  }

  StatelessWidget _buildListItem(
    List<RssListViewModel> list,
    int index,
    List<FeedItem> feeds,
  ) {
    //もしインデックスが範囲外ならno more Item
    if (list.length <= index) {
      return const Card(child: NoMoreItemIndicator());
    }
    //今日配信されていたフィードはTodayセクションに
    if (list[index].text is String) {
      //区分けはカードの隙間にテキストを挟み込んで見る
      return Card(
        margin: const EdgeInsets.all(30),
        child: Text(list[index].text!, style: const TextStyle(fontSize: 30)),
      );
    } else {
      return RssFeedItemUI(
        articles: feeds,
        index: list[index].index!,
      );
    }
  }

  ///リストに表示するためのビューモデルを生成する
  List<RssListViewModel> convertViewModel(List<FeedItem> items) {
    //Todayなどにフィードを分けるために一旦モデルに変換してから表示する
    final list = List<RssListViewModel>.empty(growable: true);
    //時間が今日ならToday 昨日ならYesterday それ以降は日付
    for (final item in items) {
      final itemTime = item.lastModified;
      final simpleItemTime =
          DateTime(itemTime.year, itemTime.month, itemTime.day);
      final todayTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      //今日
      if (simpleItemTime.day == todayTime.day) {
        if (!list.any((x) => x.text == 'Today')) {
          list.add(RssListViewModel(isSection: true, text: 'Today'));
        }
        list.add(
          RssListViewModel(isSection: false, item: item, index: item.index),
        );
      }
      //昨日はYesterday
      else if (simpleItemTime.day ==
          todayTime.add(const Duration(days: -1)).day) {
        {
          if (!list.any((x) => x.text == 'Yesterday')) {
            list.add(RssListViewModel(isSection: true, text: 'Yesterday'));
          }
          list.add(
            RssListViewModel(
              isSection: false,
              item: item,
              index: item.index,
            ),
          );
        }
      }
      //昨日以降 それ以前は普通に日付
      else {
        if (!list.any((x) => x.text == simpleItemTime.toIso8601String())) {
          list.add(
            RssListViewModel(
              isSection: true,
              text: simpleItemTime.toIso8601String(),
            ),
          );
        }
        list.add(
          RssListViewModel(
            isSection: false,
            item: item,
            index: item.index,
          ),
        );
      }
    }
    return list;
  }
}

class RssListViewModel {
  RssListViewModel({
    required this.isSection,
    this.text,
    this.item,
    this.index,
  });
  final bool isSection;
  final String? text;
  final FeedItem? item;
  final int? index;
}
