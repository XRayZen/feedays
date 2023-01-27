import 'package:flutter/material.dart';

class AppDrawerMenu extends StatefulWidget {
  const AppDrawerMenu({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<AppDrawerMenu> createState() => _AppDrawerMenuState();
}

class _AppDrawerMenuState extends State<AppDrawerMenu> {
  bool _reOrderable = false;
  void _on() {}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        //TODO:feedlyのメニューをパクる
        scrollDirection: Axis.vertical, //垂直
        child: Column(
          children: [
            SafeArea(
              minimum: const EdgeInsets.only(top: 1.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  //PLAN:コンテンツリストの順位・削除
                  onPressed: () {
                    //PLAN:ReorderableListViewのbuildDefaultDragHandlesで編集モードの切替
                    _reOrderable = _reOrderable ? true : false;
                    //TODO:プロバイダーにセットする
                  },
                  child: const Text('EDIT'),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(thickness: 1.0, height: 5),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: const Text('Today'),
                  onTap: () {
                    //PLAN:TodayPageに表示を切り替えてメニューを閉じる
                  },
                ),
                const Divider(thickness: 1.0, height: 0.05),
                ListTile(
                  leading: const Icon(Icons.bookmark_border),
                  title: const Text('Read Later'),
                  onTap: () {},
                ),
                const Divider(thickness: 1.0, height: 0.05),
                Tooltip(
                  waitDuration: const Duration(milliseconds: 700),
                  message: "今はまだ有料化するほどの機能はない",
                  child: ListTile(
                    leading: const Icon(Icons.upcoming),
                    title: const Text('Upgrade'),
                    onTap: () {},
                    enabled: false, //PLAN:今はまだ有料化するほどの機能はない
                  ),
                ),
              ],
            ),
            //購読したサイトの情報を表示するリストをツリー表示する
            //simple_tree_viewでできないか試す
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Feeds'),
              ),
            ),
            const ListTile(
              //子要素としてはListTileを入れる
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}



//TODO:とりあえず、ここでリストに入れるモックデータを書く
