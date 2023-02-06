import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/subsc_sites_provider.dart';
import 'package:feedays/ui/widgets/drag_sliver_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO:プロバイダーを使うにはこれをRiverPod仕様のwidgetに変換する必要がある
class AppDrawerMenu extends ConsumerStatefulWidget {
  const AppDrawerMenu({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerMenuState();
}

final scrollController = ScrollController();

class _DrawerMenuState extends ConsumerState<AppDrawerMenu> {
  final ScrollController _scrollController = ScrollController();
  late bool _isExpanded;
  @override
  void initState() {
    super.initState();
    _isExpanded = true;
  }

  @override
  Widget build(BuildContext context) {
    var res = ref.watch(subscriptionSiteListProvider.notifier).isEmpty();
    return Drawer(
        backgroundColor: Colors.black.withOpacity(0.5),
        //NOTE:feedlyのメニューをパクる
        child: _sliver());
  }

  Widget _sliver() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: _editButton()),
        SliverToBoxAdapter(child: _pageListTiles()),
        SliverToBoxAdapter(child: customExpansion("Feed")),
        _dragTreeListView(_isExpanded),
        SliverToBoxAdapter(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                //子要素としてはListTileを入れる
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          ),
        )
      ],
    );
  }

  //既存のExpansionPanelはSliverを使えないためカスタマイズして動作を再現
  ElevatedButton customExpansion(String listTitle) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: BeveledRectangleBorder()),
      onPressed: () {
        setState(() {
          _isExpanded = _isExpanded ? false : true;
        });
      },
      child: Row(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(10)),
          ExpandIcon(
            isExpanded: _isExpanded,
            onPressed: (bool isEx) {
              setState(() {
                _isExpanded = isEx ? false : true;
              });
            },
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Expanded(
            child: Text(listTitle),
          ),
        ],
      ),
    );
  }

  Widget _dragTreeListView(bool ignore) {
    if (!ignore) {
      return const SliverToBoxAdapter();
    } else {
      return DragReorderTreeSLiverListView();
    }
  }

  Widget _editButton() {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 5.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            //編集モードの切替
            setState(() {
              var isEditMode = ref.watch(isFeedsEditModeProvider);
              isEditMode = isEditMode == FeedsEditMode.edit
                  ? FeedsEditMode.noEdit
                  : FeedsEditMode.edit;
              ref.read(isFeedsEditModeProvider.notifier).state = isEditMode;
            });
          },
          child: const Text('EDIT'),
        ),
      ),
    );
  }

  Widget _pageListTiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1.0, height: 5),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text('Today'),
          onTap: () {
            //PLAN:TodayPageに表示を切り替えてメニューを閉じる
            
            setState(
              () {},
            );
          },
        ),
        const Divider(thickness: 1.0, height: 0.05),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Read Later'),
          onTap: () {
            setState(() {
              //今はテスト用にリストを挿入している
              var hoge = ref.watch(subscriptionSiteListProvider.notifier);
              var temp1 = WebSite.mock("1", "site1", "Anime");
              var temp2 = WebSite.mock("2", "site2", "Anime");
              var temp3 = WebSite.mock("3", "site3", "Manga");
              var temp4 = WebSite.mock("4", "site4", "Manga");
              var temp5 = WebSite.mock("5", "site5", "Anime");
              hoge.add([temp1, temp2, temp3, temp4, temp5]);
              ref.watch(webUsecaseProvider).genFakeWebsite(temp1);
              temp1 = ref.watch(webUsecaseProvider).webSites[0];
              ref.watch(selectWebSiteProvider.notifier).selectSite(temp1);
            });
          },
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
    );
  }
  //
}
