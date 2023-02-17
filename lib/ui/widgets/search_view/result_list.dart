import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultSLiverList extends ConsumerStatefulWidget {
  const ResultSLiverList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultSliverState();
}

class _ResultSliverState extends ConsumerState<ResultSLiverList> {
  int count(PreSearchResult res) {
    if (res.articles.isNotEmpty) {
      return res.articles.length;
    } else {
      return res.websites.length;
    }
  }
  //検索結果アイテムのUI
  Widget item(PreSearchResult res, int index) {
    if (res.articles.isNotEmpty) {
      return Card(
        child: ListTile(
          leading: Text(res.articles[index].title),
          onTap: () {},
        ),
      );
    } else {
      return Card(
        child: ListTile(
          leading: Text(res.websites[index].name),
          onTap: () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //NOTE:無限スクロールでは負担軽減だが検索フロー全体をリファクタしなければならないので
    //一旦Sliverにしておく
    final res = ref.watch(searchResultProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return item(res, index);
        },
        childCount: count(res),
      ),
    );
  }
}