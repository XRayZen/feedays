import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDayPage extends ConsumerStatefulWidget {
  const ToDayPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ToDayPageState();
}

class _ToDayPageState extends ConsumerState<ToDayPage> {
  @override
  Widget build(BuildContext context) {
    //テキストの下にタブバーがありFeedとトレンドページがある
    //カテゴリごとのフィードが並べる
    //スクロールするとヘッダーが上に表示される
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          const SafeArea(child: Padding(padding: EdgeInsets.only(top: 80))),
          //細かな位置調整は後
          Align(alignment: Alignment.topCenter, child: const Text("Today")),
          //タブバー
          //BUG:Listの中だと高さ制限をしないとタブバーが使えない
          //FIXME:無限スクロールを組み合わせて
          ToDayTabBar()
        ])),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => null))
      ],
    );
  }

  Widget _buildFeedList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, i) => ListTile(
        leading: CircleAvatar(
          child: Text('0'),
        ),
        title: Text('List tile #$i'),
      ),
      childCount: 4,
    ));
  }
}

class ToDayTabBar extends StatelessWidget {
  const ToDayTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Column(
        children: [
          const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.sports_baseball)),
              Tab(icon: Icon(Icons.sports_soccer)),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedsTabBarView extends StatelessWidget {
  const FeedsTabBarView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: <Widget>[
        Center(
          child: Text('野球', style: TextStyle(fontSize: 32.0)),
        ),
        Center(
          child: Text('サッカー', style: TextStyle(fontSize: 32.0)),
        ),
      ],
    );
  }
}
