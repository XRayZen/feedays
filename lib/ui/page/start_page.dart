import 'package:feedays/main.dart';
import 'package:feedays/ui/page/add_content_page.dart';
import 'package:feedays/ui/page/read_later.dart';
import 'package:feedays/ui/page/search_page.dart';
import 'package:feedays/ui/page/today_sliver_page.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.title});

  // このウィジェットは、アプリケーションのトップページになります。このウィジェットはステートフルです。
  // つまり、Stateオブジェクト(以下で定義)を持ち、このオブジェクトには見た目に影響を与えるフィールドが含まれています。

  // このクラスは、Stateのコンフィギュレーションです。親(この場合はAppウィジェット)から提供され、
  // ステートのビルドメソッドで使用される値(この場合はタイトル)を保持します。
  // Widgetのサブクラスのフィールドは、常に「final」とマークされます。

  final String title;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _counter = 0;
  int _currentPageIndex = 0;
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _incrementCounter() {
    setState(() {
      // このsetStateの呼び出しは、FlutterフレームワークにこのStateで何かがハングアップしたことを伝え、
      // 以下のbuildメソッドを再実行させ、ディスプレイに更新された値を反映させることができるようにします。
      //setState()を呼ばずに_counterを変更した場合、buildメソッドは再び呼ばれないため、何も起こらないように見える。
      //アーキテクチャ
      _counter++;
    });
  }

  void _selectedDestination(int value, BuildContext context) {
    setState(() => _currentPageIndex = value);
    //PLAN:もしくはページ遷移
    if (value == 0) {
      scaffoldStateKey.currentState!.openDrawer();
    }
  }

  List<Widget> _addPages() {
    return const [SearchPage(), AddContentPage()];
  }

  List<Widget> barpages = [
    ExampleWidget(counter: 0, currentPageIndex: 0),
    ReadlaterPage(),
    TodaySilverPage(),
    AddContentPage(),
    SearchPage()
  ];

  @override
  Widget build(BuildContext context) {
    // このメソッドは、例えば上記の_incrementCounterメソッドで行われるように、setStateが呼び出されるたびに再実行される。
    //flutterでビジネスロジックを書いたクラスをRiverpodと組み合わせたい
    // Flutter フレームワークは、ビルドメソッドの再実行が高速になるように最適化されており、
    // ウィジェットのインスタンスを個別に変更するのではなく、更新が必要なものを再構築するだけで済むようになっています。
    return Scaffold(
        key: scaffoldStateKey,
        drawer: AppDrawerMenu(
          scaffoldKey: scaffoldStateKey,
        ),
        //TODO:ページを入れ替える必要がある
        body: barpages[_currentPageIndex],
        bottomNavigationBar: DefaultTextStyle.merge(
          style: genResponsiveTextStyle(context, 28.0, 35.0, null, null, null),
          child: NavigationBar(
            onDestinationSelected: (value) =>
                _selectedDestination(value, context),
            selectedIndex: _currentPageIndex,
            animationDuration: const Duration(seconds: 1),
            elevation: 25.0, //標高
            height: getResponsiveValue(context, 100, 100, 70),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.menu),
                label: 'Menu',
                tooltip: "open a menu",
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                label: 'ReadLater',
                tooltip: "Read later",
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book),
                label: 'TodayArticle',
                tooltip: "Today articles",
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline_sharp),
                label: "AddContent",
                tooltip: 'Add Content',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: "Search",
                tooltip: "Search Content",
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
                genResponsiveTextStyle(context, 25.0, 40.0, null, null, null),
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
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  '$_currentPageIndex',
                  style: Theme.of(context).textTheme.headline4,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
