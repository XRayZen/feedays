import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/indicator/empty_list_indicator.dart';
import 'package:feedays/ui/widgets/indicator/error_indicator.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

//PLAN:この無限リストはまだUIが未完成
class TodayInfiniteList extends ConsumerStatefulWidget {
  const TodayInfiniteList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodayInfiniteListState();
}

class _TodayInfiniteListState extends ConsumerState<TodayInfiniteList> {
  final _pagingController = PagingController<int, FeedItem>(
    // 2 firstPageKey パラメータを使って、ページ初期値を設定する必要がある
    //今回使う`API`の場合、ページキーは1から始まりますが、他のAPIの場合は0から始まるかもしれない
    firstPageKey: 0,
  );
  @override
  void initState() {
    // 3 新しいページの要求をリッスンしてそれを処理する関数を登録する
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      //1 ページを要求されたら取得処理をするコードを書く
      final site = ref.watch(selectWebSiteProvider);
      final datas = await ref
          .watch(webUsecaseProvider)
          .fetchFeedDetail(site, pageKey, pageSize: 20);
      final previouslyFetchedItemsCount =
          // 2 itemListは、PagingControllerのプロパティです。
          //これまでに読み込まれたすべてのアイテムを保持します。
          //itemListの初期値はnullなので、?条件付きプロパティアクセスを使用しています。
          _pagingController.itemList?.length ?? 0;
      //取得したページがラストなのかどうか判定する
      if (ref
          .watch(webUsecaseProvider)
          .userCfg
          .rssFeedSites
          .isLastFeed(site, previouslyFetchedItemsCount)) {
        _pagingController.appendLastPage(datas!);
      } else {
        final nextPageKey = datas!.last.index;
        _pagingController.appendPage(datas, nextPageKey);
      }
    } catch (e) {
      // 4 エラーが発生した場合は、コントローラのerrorプロパティにその値を指定します。
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      //後でステートプロバイダーに入れておく
      // key: PageStorageKey<String>("Today"),
      slivers: [
        // SliverOverlapInjector(
        //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        // ),
        PagedSliverList(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedItem>(
            itemBuilder: (context, feed, index) {
              //アイテムをデザインする
              //カードにするか
              //PLAN:Todayモードだとカテゴリごとに表示する
              //その時はpagekeyではなく読み込むインデックスを初期化する
              //TODO:Widgetクラス化してモードによって表示を切り替える
              //それらのノウハウはノートに書き留めておく
              return FeedItemView(
                feed: feed,
              );
            },
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: _pagingController.refresh,
            ),
            noItemsFoundIndicatorBuilder: (context) =>
                const EmptyListIndicator(),
            noMoreItemsIndicatorBuilder: (context) => NoMoreItemIndicator(
              onTryAgain: _pagingController.refresh,
            ),
          ),
        )
      ],
    );
  }
}

class FeedItemView extends StatelessWidget {
  const FeedItemView({
    super.key,
    required this.feed,
  });
  final FeedItem feed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(feed.title),
    );
  }
}
