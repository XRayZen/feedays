// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/search/list_item/rss_feed_item_ui.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/indicator/error_indicator.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailFeedList extends ConsumerWidget {
  final WebSite site;
  const SiteDetailFeedList({
    super.key,
    required this.site,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selSite = ref.watch(selectSitePro(site));
    return selSite.when(
      data: (response) {
        return _buildList(response.feeds, ref);
      },
      error: (error, stackTrace) {
        return ErrorIndicator(
          error: error,
          //再描画するだけでフィード取得処理が走るから問題ないか
          // onTryAgain: UiProvider.instanceO.beginRebuildSiteDetailPage,
          onTryAgain: () {
            //今はリトライ処理はサイト選択プロバイダーで入れたほうが良いか
            //しかし、それより、サイト選択プロバイダー監視の前に一つRetryProviderを設置して
            //変化したら再描画させてリトライ処理を実現させる
          },
        );
      },
      loading: () {
        //PLAN:読み込み画面もこだわるべきか
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildList(List<RssFeedItem> feeds, WidgetRef ref) {
    final modelList = convertModel(feeds);
    //リストはリフレッシュでラップしてFeeditem
    return RefreshIndicator(
      onRefresh: () async {
        await ref.watch(webUsecaseProvider).fetchRssFeed(site);
        //再描画するだけでフィード取得処理が走るから問題ないか
        UiProvider.instanceO.beginRebuildSiteDetailPage();
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
    List<SiteDetailPageModel> list,
    int index,
    List<RssFeedItem> feeds,
  ) {
    //もしインデックスが範囲外ならno more Item
    if (list.length <= index) {
      return const Card(child: NoMoreItemIndicator());
    }
    //今日配信されていたフィードはTodayセクションに
    if (list[index].text is String) {
      //区分けはカードの隙間にテキストを挟み込んで見る
      return Card(
        margin: EdgeInsets.all(30),
        child: Text(list[index].text!),
      );
    } else {
      return RssFeedItemUI(
        articles: feeds,
        index: list[index].index!,
      );
    }
  }

  ///リストに表示するためのモデルを生成する
  List<SiteDetailPageModel> convertModel(List<RssFeedItem> items) {
    //Todayなどにフィードを分けるために一旦モデルに変換してから表示する
    final list = List<SiteDetailPageModel>.empty(growable: true);
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
          list.add(SiteDetailPageModel(isSection: true, text: 'Today'));
        }
        list.add(
          SiteDetailPageModel(isSection: false, item: item, index: item.index),
        );
      }
      //昨日はYesterday
      else if (simpleItemTime.day ==
          todayTime.add(const Duration(days: -1)).day) {
        {
          if (!list.any((x) => x.text == 'Yesterday')) {
            list.add(SiteDetailPageModel(isSection: true, text: 'Yesterday'));
          }
          list.add(
            SiteDetailPageModel(
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
            SiteDetailPageModel(
              isSection: true,
              text: simpleItemTime.toIso8601String(),
            ),
          );
        }
        list.add(
          SiteDetailPageModel(
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

class SiteDetailPageModel {
  SiteDetailPageModel({
    required this.isSection,
    this.text,
    this.item,
    this.index,
  });
  final bool isSection;
  final String? text;
  final RssFeedItem? item;
  final int? index;
}
