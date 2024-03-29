import 'package:feedays/ui/page/add_content/tab_web_site.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addContentPageScaffoldKey = GlobalKey<ScaffoldState>();

class AddContentPage extends ConsumerStatefulWidget {
  const AddContentPage({super.key});

  @override
  ConsumerState<AddContentPage> createState() => _AddContentPageState();
}

class _AddContentPageState extends ConsumerState<AddContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addContentPageScaffoldKey,
      body: DefaultTabController(
        //実装するページ数
        length: 1,
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
                    Tab(key: Key('TabWebSites'), text: 'WebSites'),
                    // Tab(key: Key('TabTwitter'), text: 'Twitter'),
                    // Tab(key: Key('TabReddit'), text: 'Reddit'),
                    // Tab(key: Key('TabNewsSites'), text: 'NewsSites'),
                  ],
                ),
              )
            ];
          },
          body: const TabBarView(
            children: [
              TabWebSite(),
              // Center(child: Text('Twitter')),
              // Center(child: Text('Reddit')),
              // Center(child: Text('NewsSites')),
            ],
          ),
        ),
      ),
    );
  }
}
