import 'package:feedays/ui/widgets/feeds_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDayPage extends ConsumerStatefulWidget {
  const ToDayPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ToDayPageState();
}

class _ToDayPageState extends ConsumerState<ToDayPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //TabController使う時は必ずinitStateメソッドで、初期化し、disposeメソッドで破棄
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //テキストの下にタブバーがありFeedとトレンドページがある
    //カテゴリごとのフィードが並べる
    //スクロールするとヘッダーが上に表示される
    return CustomScrollView(
      // shrinkWrap: true,
      slivers: [
        //ここらへんはスクロールしたら上に消えてるべき
        //flutterで上にスクロールするとヘッダーのみ固定するにはどうすればいいか
        //細かな位置調整は後
        const SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Today'),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            color: Colors.black,
            child: Column(
              children: [
                //タブバー
                //BUG:Listの中だと高さ制限をしないとタブバーが使えない
                //FIXME:無限スクロールを組み合わせて
                _tabbar(_tabController),
                Padding(padding: EdgeInsets.only(top: 12.5)),
                Divider(
                  height: 0.03,
                ),
              ],
            ),
          ),
        ])),
        //SLiverには
        //ビューポートの残りのスペースを埋めるスライバを作成します。
        SliverFillRemaining(
            child: FeedsTabBarView(tabController: _tabController)),
      ],
    );
  }

  Widget _tabbar(TabController controller) {
    return TabBar(
      controller: controller,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.sports_baseball)),
        Tab(icon: Icon(Icons.sports_soccer)),
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

class FeedsTabBarView extends StatelessWidget {
  const FeedsTabBarView({
    super.key,
    required this.tabController,
  });
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const <Widget>[
        Center(
          //PLAN:Todaypageはカテゴリごとにサイトの直近フィードを表示する
          //が、今は個別サイトのフィードを完成させる
          child: FeedListView(),
        ),
        Center(
          //PLAN:トレンドはapiにリクエストして表示する
          child: Text('サッカー', style: TextStyle(fontSize: 32.0)),
        ),
      ],
    );
  }
}
