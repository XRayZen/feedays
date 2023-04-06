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
    final opacity =
        ref.watch(useCaseProvider).userCfg.appConfig.uiConfig.drawerMenuOpacity;
    return Drawer(
      backgroundColor: Colors.black.withOpacity(opacity),
      child: _sliver(),
    );
  }

  Widget _sliver() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: _editButton()),
        SliverToBoxAdapter(child: upperListTiles()),
        SliverToBoxAdapter(child: customExpansion('Feed')),
        SliverVisibility(
          visible: _isExpanded,
          sliver: _dragTreeListView(_isExpanded),
          maintainState: true,
        ),
        SliverToBoxAdapter(
          child: downListTiles(),
        )
      ],
    );
  }

  Widget upperListTiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1, height: 5),
        todayTile(),
        const Divider(thickness: 1, height: 0.05),
        ListTile(
          leading: const Icon(Icons.bookmark_border),
          title: const Text('Mock用機能'),
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
            enabled: false,
            onTap: () {},
            //PLAN:今はまだ有料化するほどの機能はない
          ),
        ),
      ],
    );
  }

  Column downListTiles() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(barViewTypeProvider.notifier).state =
                TabBarViewType.addContent;
            startPageScaffoldKey.currentState!.closeDrawer();
          },
          child: const Text('Add Site'),
        ),
        const Divider(thickness: 2, height: 2),
        //透明度を設定するスライダー
        const Text('Opacity'),
        Slider(
          value: ref
              .watch(useCaseProvider)
              .userCfg
              .appConfig
              .uiConfig
              .drawerMenuOpacity,
          onChanged: (double value) {
            setState(() {
              ref
                  .watch(useCaseProvider)
                  .configUsecase
                  .updateDrawerOpacity(context, value);
            });
          },
          divisions: 10,
        ),
        const Divider(thickness: 1, height: 1),
        //これらはページ遷移にする
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Message'),
          onTap: () {
            //
          },
        ),
        ListTile(
          leading: const Icon(Icons.qr_code_scanner),
          title: const Text('QR Code Sync'),
          onTap: () {
            //
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            //
          },
        ),
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

  ListTile todayTile() {
    return ListTile(
      leading: const Icon(Icons.menu_book),
      title: const Text('Today'),
      onTap: () {
        //TodayPageに表示を切り替えてメニューを閉じる
        startPageScaffoldKey.currentState!.setState(() {
          ref.watch(barViewTypeProvider.notifier).state = TabBarViewType.toDay;
        });
        startPageScaffoldKey.currentState!.closeDrawer();
      },
      onLongPress: () async {
        //試験用に長押ししたらデータをクリアできるようにする
        await ref.watch(useCaseProvider).localRepo.clear();
        setState(() {});
      },
    );
  }
  //
}
