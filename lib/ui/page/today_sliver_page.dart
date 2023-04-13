import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/page/today/today_infinite_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayPageScaffoldKey = GlobalKey<ScaffoldState>();

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodaySilverPageState();
}

class _TodaySilverPageState extends ConsumerState<TodayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: todayPageScaffoldKey,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              //細かな位置調整は後
              SliverAppBar(
                backgroundColor: Colors.amber.withOpacity(0.7),
                pinned: true,
                expandedHeight: 100,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Today'),
                ),
                forceElevated: innerBoxIsScrolled,
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  tabs: const [
                    Tab(text: 'Today', icon: Icon(Icons.book_outlined)),
                    Tab(text: 'Trend', icon: Icon(Icons.trending_up)),
                  ],
                  onTap: (value) {
                    //feedモードを切り替える
                    if (value == 1) {
                      ref.watch(feedTypeProvider.notifier).state =
                          FeedsType.today;
                    } else if (value == 2) {
                      ref.watch(feedTypeProvider.notifier).state =
                          FeedsType.trend;
                    }
                  },
                ),
              ),
            ];
          },
          // ignore: prefer_const_constructors
          body: TabBarView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              //PLAN:Todaypageはカテゴリごとにサイトの直近フィードを表示する
              // ignore: prefer_const_constructors
              TodayInfiniteList(),
              const Center(
                //PLAN:トレンドはapiにリクエストして表示する
                child: Text('Trend', style: TextStyle(fontSize: 32.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
