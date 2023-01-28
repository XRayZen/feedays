import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/notifier_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/reorderable_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO:プロバイダーを使うにはこれをRiverPod仕様のwidgetに変換する必要がある
class AppDrawerMenu extends ConsumerStatefulWidget {
  const AppDrawerMenu({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<AppDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //I want to solve the error Vertical viewport was given unbounded height in flutter's DragAndDropLists widget.
      backgroundColor: Colors.black,
      //NOTE:feedlyのメニューをパクる
      child: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          children: [
            SafeArea(
              minimum: const EdgeInsets.only(top: 1.0),
              child: Align(
                alignment: Alignment.centerRight,
                //PLAN:コンテンツリストの順位・削除
                child: TextButton(
                  onPressed: () {
                    //PLAN:ReorderableListViewのbuildDefaultDragHandlesで編集モードの切替
                    setState(() {
                      //プロバイダーにセットする
                      var isEditMode = ref.watch(isFeedsEditModeProvider);
                      isEditMode = isEditMode == false ? true : false;
                    });
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
                    setState(() {
                      //今はテスト用にリストを挿入している
                      var hoge = ref.watch(feedsSiteListProvider.notifier);
                      var temp1 = WebSite.mock("1", "site1", "Anime");
                      var temp2 = WebSite.mock("2", "site2", "Anime");
                      var temp3 = WebSite.mock("3", "site3", "Manga");
                      var temp4 = WebSite.mock("4", "site4", "Manga");
                      hoge.add([temp1, temp2, temp3, temp4]);
                    });
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
            //constにすると再描画されなくなる
            // ignore: prefer_const_constructors
            ExpansionTile(
              title: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Feeds'),
                ),
              ),
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_constructors
                SizedBox(
                    //高さを手動で設定するだけでできたが・・・面倒
                    //PLAN:緊急避難的に静的にしているがアイテム数に応じてレスポンシブにしたい
                    height: 1000,
                    // ignore: prefer_const_constructors
                    child: DragReorderableListView()),
              ],
            ),

            // const ListTile(
            //   //子要素としてはListTileを入れる
            //   leading: Icon(Icons.message),
            //   title: Text('Messages'),
            // ),
            // const ListTile(
            //   leading: Icon(Icons.account_circle),
            //   title: Text('Profile'),
            // ),
            // const ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            // ),
          ],
        ),
      ),
    );
  }
}




//TODO:とりあえず、ここでリストに入れるモックデータを書く
