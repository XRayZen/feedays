import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailPage extends ConsumerWidget {
  const SiteDetailPage(this.site, {super.key});
  final WebSite site;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //バックボタン(leading)はハートボタンでお気に入り登録
          //バーはフレキシブルで最後にFOLLOWテキストボタン
          //スクロールした後のタイトルはサイトの名前
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            pinned: true,
            expandedHeight: 100,
            actions: [
              TextButton(
                onPressed: () {
                  //購読処理
                  //feedlyではスライドしてフォルダを選択するがここはダイアログで選択する
                },
                child: const ColoredBox(
                  color: Colors.green,
                  child: Text('FOLLOW'),
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                //スペーサーを指定して隙間を開けておく
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(site.name),
                  IconButton(
                    onPressed: () {
                      //お気に入り登録
                    },
                    icon: const Icon(Icons.favorite),
                  )
                ],
              ),
              centerTitle: true,
            ),
          ),
          //リストはリフレッシュでラップしてFeeditemを参考
          //今日配信されていたフィードはTodayセクションに
          //昨日はYesterday
          //それ以前は普通に日付
          //区分けはカードの隙間にテキストを挟み込んで見る
          
        ],
      ),
    );
  }
}
