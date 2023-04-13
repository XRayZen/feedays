import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/main.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/dialog/site_edit_dialog.dart';
import 'package:feedays/ui/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionSiteList extends ConsumerStatefulWidget {
  const SubscriptionSiteList({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReorderableTreeListViewState();
}

class _ReorderableTreeListViewState
    extends ConsumerState<SubscriptionSiteList> {
  @override
  Widget build(BuildContext context) {
    final res = ref.watch(subscribeWebSitesProvider);
    //このフラグがオンなら色々とアイコンの位置をずらす必要がある
    final isEditFlg = _isEditMode(ref.watch(isFeedsEditModeProvider));
    if (res.isEmpty) {
      return const SliverToBoxAdapter(child: Center(child: Text('リストが空です')));
    } else {
      //カテゴリータイルにドラッグアンドドロップしたらそれを特定して
      //入れ替え処理を行う
      //編集モードの切替で右にメニューアイコンを表示させてドラッグ可能か判断できるようにする
      return DragAndDropLists(
        children: _buildList(ref.watch(subscribeWebSitesProvider)),
        onItemReorder: _onChildItemReorder,
        onListReorder: _onListReorder,
        //trueの場合、長押しした後にアイテムをドラッグします。falseの場合は、すぐにドラッグします。
        itemDragOnLongPress: true,
        //リストのドラッグを長押しと短押しのどちらで行うかを指定します。
        //trueの場合、長押しの後にリストがドラッグされます。falseの場合、リストはすぐにドラッグされます。
        listDragOnLongPress: isEditFlg,
        //スライバと互換性のあるリストを返すかどうか。sliver として使用する場合は true を設定する。
        //true の場合、[scrollController] を提供する必要がある。ウィジェットのみで使用する場合は false に設定する。
        sliverList: true,
        scrollController: scrollController, //親スクロールコントローラーとつなげる
        // ScrollController(),
        // listPadding: const EdgeInsets.all(3),
        itemDivider: Divider(
          thickness: 2,
          height: 2,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10),
        ),
        itemDecorationWhileDragging: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        listGhost: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 100),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.add_box),
            ),
          ),
        ),
        itemGhost: Padding(
          // ignore: use_named_constants
          padding: const EdgeInsets.symmetric(),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.add_box),
            ),
          ),
        ),
        lastItemTargetHeight: 10,
        addLastItemTargetHeightToTop: true,
        lastListTargetSize: 0,
        listDragHandle: _buildDragHandle(isList: true, isEditMode: isEditFlg),
        itemDragHandle: _buildDragHandle(isEditMode: isEditFlg),
        itemOnAccept: _dragItemAccept,
      );
    }
  }

  //ドラッグされて投下されたら
  void _dragItemAccept(DragAndDropItem incoming, DragAndDropItem target) {
    //アイテムが受け入れられた後、ドラッグ＆ドロップ操作に関与するアイテムを取得するために設定される。
    //並べ替えだけが必要な一般的なユースケースでは、[onItemReorder] または [onItemAdd] だけが必要で、
    //これは null のままにしておく必要があります。[onItemReorder] または [onItemAdd] は、この後に呼び出されます。
  }

  bool _isEditMode(FeedsEditMode isMode) {
    if (isMode == FeedsEditMode.edit) {
      return true;
    } else {
      return false;
    }
  }

  DragHandle? _buildDragHandle({bool isList = false, bool isEditMode = false}) {
    //位置がずれるのを直せた
    //参考:https://www.youtube.com/watch?v=HmiaGyf55ZM
    final alignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final handle = DragHandle(
      onLeft: isList,
      verticalAlignment: alignment,
      child: Container(
        padding: EdgeInsets.only(
          right: isList ? 10 : 10,
          top: isList ? 15 : 0,
          left: isList ? 15 : 10,
        ),
        child: const Icon(Icons.menu),
      ),
    );
    return isEditMode ? handle : null;
  }

  //個別のアイテムの入れ替え
  void _onChildItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    //FIXME:リストの並び替えもRssUseCase経由で行う
    setState(() {
      ref.watch(rssUsecaseProvider).rssFeedData.onReorderSiteIndex(
            oldItemIndex,
            oldListIndex,
            newItemIndex,
            newListIndex,
          );
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      //FIXME:リストの並び替えもRssUseCase経由で行う
      ref
          .watch(rssUsecaseProvider)
          .rssFeedData
          .onReorderFolder(oldListIndex, newListIndex);
    });
  }

  List<DragAndDropListExpansion> _buildList(List<RssFeedFolder> nodes) {
    final widgets = <DragAndDropListExpansion>[];

    for (final node in nodes) {
      widgets.add(
        DragAndDropListExpansion(
          //この項目がドラッグ可能かどうか。並べ替えが可能な場合は true を設定します。固定でなければならない場合はfalseに設定します。
          canDrag: _isEditMode(ref.watch(isFeedsEditModeProvider)),
          //PLAN:開封状態をプロバイダー経由で保持する
          initiallyExpanded: true,
          disableTopAndBottomBorders: false, //拡大時に上下に表示されるボーダーを無効化する。
          listKey: ObjectKey(node),
          trailing: _isEditMode(ref.watch(isFeedsEditModeProvider))
              ? IconButton(
                  onPressed: () {
                    //フォルダー削除するか確認する
                    deleteFolderDialog(node);
                  },
                  icon: const Icon(Icons.delete),
                )
              : null,
          title: Text(node.name),
          leading: _isEditMode(ref.watch(isFeedsEditModeProvider))
              ? const Padding(padding: EdgeInsets.only(left: 10))
              : const Icon(Icons.ac_unit),
          //  const Icon(Icons.ac_unit),
          //PLAN:feedlyを真似てアロートグルを右に寄せる
          //書き換えてもトグルスイッチの時にアニメコントローラーに指示しないと動かない
          // trailing: ExpansionTileCustomAnimeWidget(),
          onExpansionChanged: (bool value) {
            //PLAN:開封状態をプロバイダーに伝える
            //コントローラーをステートプロバイダーにしてここで指示する
            //disposeでエラーが出る
            //NOTE:コントローラーの廃棄タイミングをこのウィジェットにする
            //今だとタイルごとに廃棄しているからエラーが出る
            // ref.watch(expansionTileCustomAnimePro);
            // setState(() {
            //   if (value) {
            //     expansionTileCustomAnimePro[0].forward();
            //   } else {
            //     expansionTileCustomAnimePro[0].reverse().then<void>((value) {
            //       if (!mounted) return;
            //       setState(() {});
            //     });
            //   }
            // });
          },
          children: _buildTreeChildNode(node.name, node.children, ref),
        ),
      );
    }
    return widgets;
  }

  Future<dynamic> deleteFolderDialog(RssFeedFolder node) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final folderName = node.name;
        return AlertDialog(
          title: Text('Delete Category $folderName '),
          content: Text('Do you want to delete the $folderName ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //フォルダー削除
                setState(() {
                  ref.watch(rssUsecaseProvider).removeSiteFolder(node.name);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  List<DragAndDropItem> _buildTreeChildNode(
    String folderName,
    List<WebSite> models,
    WidgetRef ref,
  ) {
    if (models.isEmpty) {
      return [];
    }
    return models.map((site) {
      return DragAndDropItem(
        canDrag: _isEditMode(ref.watch(isFeedsEditModeProvider)),
        //feedlyと同様タップしたらドロワーメニューを閉じてサイトのfeedPageにページを切り替える
        child: ListTile(
          title: Row(
            children: [
              Visibility(
                visible: _isEditMode(ref.watch(isFeedsEditModeProvider)),
                child: IconButton(
                  onPressed: () {
                    //削除するかどうか確認するダイアログを表示する
                    showSiteEditDialog(folderName, site, context);
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  site.name,
                ),
              ),
            ],
          ),
          onTap: () async {
            //タップしたらWebSiteを選択してサイト詳細ページにタブバービューを変更する
            //ページ遷移ではない
            ref.watch(selectWebSiteProvider.notifier).selectSite(site);
            startPageScaffoldKey.currentState!.setState(() {
              ref.watch(barViewTypeProvider.notifier).state =
                  TabBarViewType.siteDetail;
            });
            startPageScaffoldKey.currentState!.closeDrawer();
            setState(() {});
          },
          onLongPress: () {
            showSiteEditDialog(folderName, site, context);
          },
        ),
      );
    }).toList();
  }
}
