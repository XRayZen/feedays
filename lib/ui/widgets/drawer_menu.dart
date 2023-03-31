// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:feedays/main.dart';
import 'package:feedays/mock/mock_util.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/drawer/subsc_site_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawerMenu extends ConsumerStatefulWidget {
  const AppDrawerMenu({
    super.key,
  });

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
    final _add = ref.watch(onChangedProvider);
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
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(barViewTypeProvider.notifier).state =
                      TabBarViewType.addContent;
                  startPageScaffoldKey.currentState!.closeDrawer();
                },
                child: const Text('Add Content'),
              ),
              const ListTile(
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
      return SubscriptionSiteList();
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
            //TodayPageに表示を切り替えてメニューを閉じる
            startPageScaffoldKey.currentState!.setState(() {
              ref.watch(barViewTypeProvider.notifier).state =
                  TabBarViewType.toDay;
            });
            startPageScaffoldKey.currentState!.closeDrawer();
          },
          onLongPress: () async {
            setState(() async {
              //試験用に長押ししたらデータをクリアできるようにする
              await ref.watch(useCaseProvider).localRepo.clear();
            });
          },
        ),
        const Divider(thickness: 1, height: 0.05),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Read Later'),
          onTap: () async {
            final mockValidSites = await genValidSite();
            //今はテスト用にリストを挿入している
            await ref
                .watch(useCaseProvider)
                .rssUsecase
                .registerRssSite(mockValidSites);
            // セットステートでUIを再描画させる
            setState(() {});
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
            enabled: false,
            //PLAN:今はまだ有料化するほどの機能はない
          ),
        ),
      ],
    );
  }
  //
}
