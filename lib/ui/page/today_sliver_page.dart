import 'package:feedays/ui/widgets/feed_silver_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodaySilverPage extends ConsumerStatefulWidget {
  const TodaySilverPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodaySilverPageState();
}

class _TodaySilverPageState extends ConsumerState<TodaySilverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    Tab(text: 'Today', icon: Icon(Icons.book_outlined)),
                    Tab(text: 'Trend', icon: Icon(Icons.trending_up)),
                  ],
                ),
              ),
            ];
          },
          // ignore: prefer_const_constructors
          body: TabBarView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              //PLAN:Todaypageはカテゴリごとにサイトの直近フィードを表示する
              //が、今は個別サイトのフィードを完成させる
              // ignore: prefer_const_constructors
              FeedSliverListView(),
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
