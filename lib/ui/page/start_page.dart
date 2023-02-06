import 'package:feedays/main.dart';
import 'package:feedays/ui/page/add_content_page.dart';
import 'package:feedays/ui/page/read_later.dart';
import 'package:feedays/ui/page/search_page.dart';
import 'package:feedays/ui/page/today_sliver_page.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util.dart';

class StartPageView extends ConsumerStatefulWidget {
  StartPageView({required this.title, super.key});
  final String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartPageViewState();
}

class _StartPageViewState extends ConsumerState<StartPageView> {
  int _currentPageIndex = 0;
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    //BUG:リストごと入れるのではなく個別のページに分ける
    // ref.read(mainNavigationPageProvider.notifier).add(barpages);
  }

  void _selectedDestination(int value, BuildContext context) {
    setState(() {
      _currentPageIndex = value;
      ref.watch(selectedMainPageProvider.notifier).state = value;
    });
    //PLAN:もしくはページ遷移
    if (value == 0) {
      scaffoldStateKey.currentState!.openDrawer();
    }
  }

  //TODO:プロバイダーに移行する
  List<Widget> barpages = [
    ExampleWidget(counter: 0, currentPageIndex: 0),
    ReadlaterPage(),
    TodaySilverPage(),
    AddContentPage(),
    SearchPage()
  ];
  @override
  Widget build(BuildContext context) {
    //BUG:なぜか変更されたのに更新しない
    final index = ref.watch(selectedMainPageProvider.notifier).state;
    
    //scaffoldStateKeyでステートを呼び出せばsetState出来る
    return Scaffold(
        key: scaffoldStateKey,
        drawer: AppDrawerMenu(
          scaffoldKey: scaffoldStateKey,
        ),
        //TODO:プロバイダーによってページを入れ替える必要がある
        
        body: barpages[index],
        // barpages[_currentPageIndex],
        bottomNavigationBar: DefaultTextStyle.merge(
          style: genResponsiveTextStyle(context, 28, 35, null, null, null),
          child: NavigationBar(
            onDestinationSelected: (value) =>
                _selectedDestination(value, context),
            selectedIndex: _currentPageIndex,
            animationDuration: const Duration(seconds: 1),
            elevation: 25, //標高
            height: getResponsiveValue(context, 100, 100, 70),
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
        ));
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({
    Key? key,
    required int counter,
    required int currentPageIndex,
  })  : _counter = counter,
        _currentPageIndex = currentPageIndex,
        super(key: key);

  final int _counter;
  final int _currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() {}),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DefaultTextStyle.merge(
            style:
                genResponsiveTextStyle(context, 25, 40, null, null, null),
            child: Column(
              // Column はレイアウトウィジェットでもあります。
              //子供のリストを受け取り、それらを縦に並べます。
              //デフォルトでは、子プロセスの水平サイズに合うように自分自身のサイズを調整し、親プロセスと同じ高さになるように試みます。
              //
              // 各ウィジェットのワイヤーフレームを見るために "デバッグペイント" を起動する
              //（コンソールで "p" を押す、Android Studio の Flutter Inspector から "Toggle Debug Paint" アクションを選ぶ、
              //または Visual Studio Code で "Toggle Debug Paint" コマンドを選ぶ）。
              //
              // Column には、それ自身のサイズとその子の位置を制御するための様々なプロパティがあります。
              //ここでは、mainAxisAlignment を使用して、子カラムを垂直方向に配置しています。
              //Column が垂直方向であるため、ここでの主軸は垂直軸です（横軸は水平方向となります）。
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'これだけボタンが押されているのだから:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$_currentPageIndex',
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
