import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/search/list_item/rss_feed_item_ui.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailFeedList extends ConsumerStatefulWidget {
  const SiteDetailFeedList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SiteDetailFeedListState();
}

enum SiteFeedListViewType { loading, success, notFound, error }

final siteFeedListViewTypePro = StateProvider<SiteFeedListViewType>((ref) {
  return SiteFeedListViewType.notFound;
});

class _SiteDetailFeedListState extends ConsumerState<SiteDetailFeedList> {
  @override
  Widget build(BuildContext context) {
    final viewType = ref.watch(siteFeedListViewTypePro);
    switch (viewType) {
      case SiteFeedListViewType.loading:
        return const SliverToBoxAdapter(child: CircularProgressIndicator());
      case SiteFeedListViewType.success:
        final res = ref.watch(selectSiteRssFeedProvider);
        return _buildList(res);
      case SiteFeedListViewType.notFound:
        return const SliverToBoxAdapter(child: NoMoreItemIndicator());
      case SiteFeedListViewType.error:
        return const SliverToBoxAdapter(child: NoMoreItemIndicator());
    }
  }

  Widget _buildList(List<RssFeedItem> feeds) {
    final modelList = convertModel(feeds);
    //リストはリフレッシュでラップしてFeeditem
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildListItem(modelList, index, feeds);
        },
        childCount: modelList.length,
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
        //BUG:一回しか入らないはずが毎回入れられてる
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
