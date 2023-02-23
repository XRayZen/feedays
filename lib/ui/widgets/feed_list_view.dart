// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'indicator/empty_list_indicator.dart';
import 'indicator/error_indicator.dart';

class FeedListView extends ConsumerStatefulWidget {
  const FeedListView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedListState();
}

class _FeedListState extends ConsumerState<FeedListView> {
  final _pagingController = PagingController<int, RssFeedItem>(
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
          .fetchFeedDetail(site, pageKey, pageSize: 10);
      final previouslyFetchedItemsCount =
          // 2 itemListは、PagingControllerのプロパティです。
          //これまでに読み込まれたすべてのアイテムを保持します。
          //itemListの初期値はnullなので、?条件付きプロパティアクセスを使用しています。
          _pagingController.itemList?.length ?? 0;
      //取得したページがラストなのかどうか判定する
      if (ref
          .watch(webUsecaseProvider).userCfg.rssFeedSites
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
    //サイトが選択もしくはAllが選択されたらビジネスロジックを呼んでサイトのフィードを取得してリストに追加して表示する
    //これで遅延読み込みを習得する
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2 PagingController は refresh() というデータを更新する関数を定義している
        //refresh() の呼び出しを Future でラップしているのは、
        //RefreshIndicator の onRefresh パラメータがそれを想定しているから
        () => _pagingController.refresh(),
      ),
      child: PagedListView(
        primary: false,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<RssFeedItem>(
          itemBuilder: (context, feed, index) {
            //アイテムをデザインする
            //カードにするか
            //PLAN:Todayモードだとカテゴリごとに表示する
            //その時はpagekeyではなく読み込むインデックスを初期化する
            return ListTile(
              title: Text(feed.title),
            );
          },
          animateTransitions: true,
          firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
            error: _pagingController.error,
            onTryAgain: () => _pagingController.refresh(),
          ),
          noItemsFoundIndicatorBuilder: (context) => const EmptyListIndicator(),
          noMoreItemsIndicatorBuilder: (context) => NoMoreItemIndicator(
            onTryAgain: () => _pagingController.refresh(),
          ),
        ),
      ),
    );
  }
}
