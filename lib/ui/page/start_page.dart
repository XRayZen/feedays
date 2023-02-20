import 'package:feedays/main.dart';
import 'package:feedays/ui/page/add_content_page.dart';
import 'package:feedays/ui/page/power_search_page.dart';
import 'package:feedays/ui/page/read_later.dart';
import 'package:feedays/ui/page/today_sliver_page.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:feedays/ui/widgets/search_view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartPageView extends ConsumerStatefulWidget {
  const StartPageView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartPageViewState();
}

const List<Widget> pageList = <Widget>[
  ReadlaterPage(),
  TodaySilverPage(),
  AddContentPage(),
  PowerSearchPage(),
  SearchViewPage()
];

class _StartPageViewState extends ConsumerState<StartPageView> {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  PageType howPageIndex(int value) {
    if (value == 1) {
      return PageType.readLater;
    } else if (value == 2) {
      return PageType.toDay;
    } else if (value == 3) {
      return PageType.addContent;
    } else if (value == 4) {
      return PageType.powerSearch;
    } else {
      return PageType.toDay;
    }
  }

  void _selectedDestination(int value, BuildContext context) {
    setState(() {
      ref.watch(barPageTypeProvider.notifier).state = howPageIndex(value);
    });
    if (value == 0) {
      startPageScaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: startPageScaffoldKey,
      // ignore: prefer_const_constructors
      drawer: AppDrawerMenu(key: Key('DrawerMenu')),
      // ignore: prefer_const_constructors
      body: ViewPage(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => _selectedDestination(value, context),
        animationDuration: const Duration(seconds: 3),
        // elevation: 20, //標高
        // height: getResponsiveValue(context, 100, 100, 70),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
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
      ),
    );
  }
}

class ViewPage extends ConsumerWidget {
  const ViewPage({super.key});
  Widget howPage(
    PageType type,
  ) {
    switch (type) {
      case PageType.readLater:
        return pageList[0];
      case PageType.toDay:
        return pageList[1];
      case PageType.addContent:
        return pageList[2];
      case PageType.powerSearch:
        return pageList[3];
      case PageType.searchView:
        return pageList[4];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageType = ref.watch(barPageTypeProvider);
    return howPage(pageType);
  }
}
