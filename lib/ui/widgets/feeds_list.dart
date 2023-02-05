// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedays/ui/provider/state_provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FeedListView extends ConsumerStatefulWidget {
  const FeedListView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedListState();
}

class _FeedListState extends ConsumerState<FeedListView> {
  final _pagingController = PagingController<int, RssFeed>(
    // 2 firstPageKey パラメータを使って、ページ初期値を設定する必要がある
    //今回使う`API`の場合、ページキーは1から始まりますが、他のAPIの場合は0から始まるかもしれない
    firstPageKey: 0,
  );
  @override
  void initState() {
    // 3 新しいページの要求をリッスンしてそれを処理する関数を登録する
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    //ページを要求されたら取得処理をするコードを書く
    ref.watch(webUsecaseProvider).genFakeWebsite();
    var length = ref.watch(webUsecaseProvider).webSites.length;
    print("length:{$length}");
    final site = ref.watch(selectWebSiteProvider);
    // 要求するページ数と
    var datas =
        ref.watch(webUsecaseProvider).fetchFeed(site, pageKey, pageSize: 10);
    final previouslyFetchedItemsCount =
        // 2 itemListは、PagingControllerのプロパティです。
        //これまでに読み込まれたすべてのアイテムを保持します。
        //itemListの初期値はnullなので、?条件付きプロパティアクセスを使用しています。
        _pagingController.itemList?.length ?? 0;
    //取得したページがラストなのかどうか判定する
    if (ref
        .watch(webUsecaseProvider)
        .isLastFeed(site, previouslyFetchedItemsCount)) {
      _pagingController.appendLastPage(datas!);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(datas!, nextPageKey);
    }
    try {
      //レポジトリで新しいページを要求する
    } catch (e) {
      // 4 エラーが発生した場合は、コントローラのerrorプロパティにその値を指定します。
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    // 4 コントローラを dispose() するのを忘れないように
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //サイトが選択もしくはAllが選択されたらビジネスロジックを呼んでサイトのフィードを取得してリストに追加して表示する
    //flutterのビジネスロジックインスタンス・依存性注入のやり方が分かったら再開できるか
    //リストはパッケージのinfinite_scroll_paginationを使う
    //これで遅延読み込みを習得する
    var feeds = ref.watch(rssFeedsProvider);
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2 PagingController は refresh() というデータを更新する関数を定義している
        //refresh() の呼び出しを Future でラップしているのは、
        //RefreshIndicator の onRefresh パラメータがそれを想定しているから
        () => _pagingController.refresh(),
      ),
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<RssFeed>(
          itemBuilder: (context, feed, index) {
            //アイテムをデザインする
            //カードにするか
            return ListTile(
              title: Text(feed.title),
            );
          },
          firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
            error: _pagingController.error,
            onTryAgain: () => _pagingController.refresh(),
            context: context,
          ),
          noItemsFoundIndicatorBuilder: (context) =>
              EmptyListIndicator(context: context),
        ),
      ),
    );
  }
}

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator(
      {super.key,
      required this.error,
      required this.onTryAgain,
      required this.context});
  final BuildContext context;
  final Object error;
  final Function onTryAgain;
  @override
  Widget build(BuildContext context) {
    return  Text("Error :{$error}");
  }
}

class EmptyListIndicator extends StatelessWidget {
  const EmptyListIndicator({super.key, required this.context});
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return  const Text("Empty List");
  }
}
