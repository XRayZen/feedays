import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/page/detail/feed_detail_page.dart';
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
      //記事の場合はリーディングにアイコンを配置する
      //タイトルは太字
      //最後にディスクリプション
      return Card(
        child: ListTile(
          leading: SizedBox.square(
            child: Image.memory(res.articles[index].image.buffer.asUint8List()),
          ),
          title: Text(res.articles[index].title),
          subtitle: Text(res.articles[index].description),
          onTap: () {
            //タップしたらフィード詳細ページに遷移
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FeedDetailPage(index: index, articles: res.articles),
              ),
            );
          },
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
