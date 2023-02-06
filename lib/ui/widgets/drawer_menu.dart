// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/subsc_sites_provider.dart';
import 'package:feedays/ui/widgets/site_feed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawerMenu extends ConsumerStatefulWidget {
  const AppDrawerMenu({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerMenuState();
}

final scrollController = ScrollController();

class _DrawerMenuState extends ConsumerState<AppDrawerMenu> {
  late bool _isExpanded;
  @override
  void initState() {
    super.initState();
    _isExpanded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.5),
      //NOTE:feedlyのメニューをパクる
      child: _sliver(),
    );
  }

  Widget _sliver() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: _editButton()),
        SliverToBoxAdapter(child: _pageListTiles()),
        SliverToBoxAdapter(child: customExpansion('Feed')),
        SliverVisibility(
          visible: _isExpanded,
          sliver: _dragTreeListView(_isExpanded),
          maintainState: true,
          // maintainAnimation: true,
          // maintainSize: true  ,
        ),
        // _dragTreeListView(_isExpanded),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  //TODO:Add Content Pageにタブを切り替える
                },
                child: const Text('Add Content'),
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
        )
      ],
    );
  }

  //既存のExpansionPanelはSliverを使えないためカスタマイズして動作を再現
  ElevatedButton customExpansion(String listTitle) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const BeveledRectangleBorder()),
      onPressed: () {
        setState(() => _isExpanded = _isExpanded ? false : true);
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
      //無視しないと即座に反映されない
      // ignore: prefer_const_constructors
      return SiteFeedSLiverView();
    }
  }

  Widget _editButton() {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 5),
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
        const Divider(thickness: 1, height: 5),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text('Today'),
          onTap: () {
            //PLAN:TodayPageに表示を切り替えてメニューを閉じる
            //BUG:これだとページ遷移出来ない
            //どうやらメインページがsetStateしないと反映されない
            //プロバイダーが働いていない
            //
            final fff = ref.watch(selectedMainPageProvider);
            // fff.state = 2;
            // fff.update((state) => state = 2);
            // scaffoldStateKeyでも反映できない
            // setState(
            //   () {

            //   },
            // );
          },
        ),
        const Divider(thickness: 1, height: 0.05),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Read Later'),
          onTap: () {
            setState(() {
              //今はテスト用にリストを挿入している
              final fakeFeeds = ref.watch(subscriptionSiteListProvider.notifier);
              var temp1 = WebSite.mock('1', 'site1', 'Anime');
              final temp2 = WebSite.mock('2', 'site2', 'Anime');
              final temp3 = WebSite.mock('3', 'site3', 'Manga');
              final temp4 = WebSite.mock('4', 'site4', 'Manga');
              final temp5 = WebSite.mock('5', 'site5', 'Anime');
              fakeFeeds.add([temp1, temp2, temp3, temp4, temp5]);
              ref.watch(webUsecaseProvider).genFakeWebsite(temp1);
              temp1 = ref.watch(webUsecaseProvider).user.subscribeSites[0];
              ref.watch(selectWebSiteProvider.notifier).selectSite(temp1);
            });
          },
        ),
        const Divider(thickness: 1, height: 0.05),
        Tooltip(
          waitDuration: const Duration(milliseconds: 700),
          message: '今はまだ有料化するほどの機能はない',
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
