// ignore_for_file: prefer_const_constructors

import 'package:feedays/main.dart';
import 'package:feedays/ui/page/add_content_page.dart';
import 'package:feedays/ui/page/detail/site_detail_page.dart';
import 'package:feedays/ui/page/power_search_page.dart';
import 'package:feedays/ui/page/read_later.dart';
import 'package:feedays/ui/page/search_view_page.dart';
import 'package:feedays/ui/page/today_sliver_page.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartPageView extends ConsumerStatefulWidget {
  const StartPageView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartPageViewState();
}

final List<Widget> pageList = <Widget>[
  ReadlaterPage(),
  TodayPage(),
  AddContentPage(),
  PowerSearchPage(),
  SearchViewPage(),
  SiteDetailPage()
];

class _StartPageViewState extends ConsumerState<StartPageView> {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  TabBarViewType howPageIndex(int value) {
    if (value == 1) {
      return TabBarViewType.readLater;
    } else if (value == 2) {
      return TabBarViewType.toDay;
    } else if (value == 3) {
      return TabBarViewType.addContent;
    } else if (value == 4) {
      return TabBarViewType.powerSearch;
    } else {
      return TabBarViewType.toDay;
    }
  }

  void _selectedDestination(int value, BuildContext context) {
    setState(() {
      if (value == 0) {
        startPageScaffoldKey.currentState!.openDrawer();
      } else {
        ref.watch(barViewTypeProvider.notifier).state = howPageIndex(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return appInit(context);
  }

  ///ここでデータ読み込み処理
  Widget appInit(BuildContext context) {
    return ref.watch(appInitProvider).when(
      data: (data) {
        return buildStartPage(context);
      },
      error: (error, stackTrace) {
        //エラーで読み込めなかったら初回処理とする
        return buildStartPage(context);
      },
      loading: () {
        //データを読み込み処理をしめす
        return CircularProgressIndicator();
      },
    );
  }

  Scaffold buildStartPage(BuildContext context) {
    return Scaffold(
      key: startPageScaffoldKey,
      // ignore: prefer_const_constructors
      drawer: AppDrawerMenu(key: Key('DrawerMenu')),
      // ignore: prefer_const_constructors
      body: BarView(),
      bottomNavigationBar: btmNavigationBar(context),
    );
  }

  NavigationBar btmNavigationBar(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (value) => _selectedDestination(value, context),
      animationDuration: const Duration(seconds: 3),
      elevation: 20, //標高
      // height: getResponsiveValue(context, 100, 100, 70),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      // backgroundColor: Colors.black,
      // surfaceTintColor: Colors.black,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.menu),
          label: 'Menu',
          tooltip: 'open a menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmark_border),
          label: 'ReadLater',
          tooltip: 'Read later',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book),
          label: 'TodayArticle',
          tooltip: 'Today articles',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_sharp),
          label: 'AddContent',
          tooltip: 'Add Content',
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Search',
          tooltip: 'Search Content',
        )
      ],
    );
  }
}

class BarView extends ConsumerWidget {
  const BarView({super.key});
  Widget howPage(
    TabBarViewType type,
  ) {
    switch (type) {
      case TabBarViewType.readLater:
        return pageList[0];
      case TabBarViewType.toDay:
        return pageList[1];
      case TabBarViewType.addContent:
        return pageList[2];
      case TabBarViewType.powerSearch:
        return pageList[3];
      case TabBarViewType.searchView:
        return pageList[4];
      case TabBarViewType.siteDetail:
        return pageList[5];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageType = ref.watch(barViewTypeProvider);
    return howPage(pageType);
  }
}
