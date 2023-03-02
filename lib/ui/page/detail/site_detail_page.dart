// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/ui/page/detail/site_datail/site_feed_list.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailPage extends ConsumerStatefulWidget {
  const SiteDetailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiteDetailState();
}

class _SiteDetailState extends ConsumerState<SiteDetailPage> {
  @override
  Widget build(BuildContext context) {
    final site = ref.watch(selectWebSiteProvider);
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
                    onPressed: () async {
                      //お気に入り登録
                    },
                    icon: const Icon(Icons.favorite),
                  )
                ],
              ),
              centerTitle: true,
            ),
          ),
          const SiteDetailFeedList(),
        ],
      ),
    );
  }
}
