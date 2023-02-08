import 'package:feedays/ui/page/add_content/web_sites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addContentPageScaffoldKey = GlobalKey<ScaffoldState>();

class AddContentPage extends ConsumerStatefulWidget {
  const AddContentPage({super.key});

  @override
  ConsumerState<AddContentPage> createState() => _AddContentPageState();
}

//// TODO(@XRayZen):UI: #6 コンテンツ追加ページを実装する
class _AddContentPageState extends ConsumerState<AddContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addContentPageScaffoldKey,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                expandedHeight: 100,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  //PLAN:細かな位置調整は後
                  title: Text('Add Content'),
                ),
              ),
              const SliverToBoxAdapter(
                child: TabBar(
                  tabs: [
                    Tab(text: 'WebSites'),
                    Tab(text: 'Twitter'),
                    Tab(text: 'Reddit'),
                    Tab(text: 'NewsSites'),
                  ],
                ),
              )
            ];
          },
          body: const TabBarView(
            children: [
              WebSites(),
              Center(child: Text('Twitter')),
              Center(child: Text('Reddit')),
              Center(child: Text('NewsSites')),
            ],
          ),
        ),
      ),
    );
  }
}
