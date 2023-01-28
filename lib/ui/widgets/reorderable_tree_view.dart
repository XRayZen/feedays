import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:feedays/ui/model/feed_model.dart';
import 'package:feedays/ui/provider/notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DragReorderableListView extends ConsumerStatefulWidget {
  const DragReorderableListView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReorderableTreeListViewState();
}

class _ReorderableTreeListViewState
    extends ConsumerState<DragReorderableListView> {
  @override
  Widget build(BuildContext context) {
    var res = ref.watch(feedsSiteListProvider.notifier);
    if (res.isEmpty()) {
      return const Center(child: Text('リストが空です'));
    } else {
      //カテゴリータイルにドラッグアンドドロップしたらそれを特定して
      //入れ替え処理を行う
      //編集モードの切替で右にメニューアイコンを表示させてドラッグ可能か判断できるようにする
      //NOTE:`DragAndDropLists`はページなら静的な高さは要らないが、ドロワーメニューでは静的な高さ設定が必要
      return DragAndDropLists(
        children: _buildList(ref.watch(feedsSiteListProvider)),
        onItemReorder: _onChildItemReorder,
        onListReorder: _onListReorder,
        listPadding: const EdgeInsets.all(5),
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
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        listGhost: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: const Icon(Icons.add_box),
            ),
          ),
        ),
        itemGhost: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Icon(Icons.add_box),
            ),
          ),
        ),
        lastItemTargetHeight: 10,
        addLastItemTargetHeightToTop: true,
        lastListTargetSize: 40,
        listDragHandle: _buildDragHandle(isList: true),
        itemDragHandle: _buildDragHandle(),
        itemOnAccept: _dragItemAccept,
      );
    }
  }

  //ドラッグされて投下されたら
  void _dragItemAccept(DragAndDropItem incoming,DragAndDropItem target) {

  }

  _buildDragHandle({bool isList = false}) {
    //参考:https://www.youtube.com/watch?v=HmiaGyf55ZM
    final alignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    return DragHandle(
      verticalAlignment: alignment,
      child: Container(
        padding: EdgeInsets.only(right: isList ? 0 : 10, top: isList ? 20 : 0),
        child: const Icon(Icons.menu),
      ),
    );
  }

  //個別のアイテムの入れ替え
  _onChildItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    ref
        .watch(feedsSiteListProvider.notifier)
        .onItemReorder(oldItemIndex, oldListIndex, newItemIndex, newListIndex);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    ref
        .watch(feedsSiteListProvider.notifier)
        .onListReorder(oldListIndex, newListIndex);
  }

  _buildList(List<FeedModel> nodes) {
    List<DragAndDropListExpansion> widgets = [];
    for (var node in nodes) {
      widgets.add(DragAndDropListExpansion(
          // initiallyExpanded: true,
          listKey: ObjectKey(node),
          title: Text('${node.name}'),
          leading: const Icon(Icons.ac_unit),
          children: _buildTreeChilledNode(node.nodes)));
    }
    return widgets;
  }

  List<DragAndDropItem> _buildTreeChilledNode(List<FeedModel> models) {
    if (models.isEmpty) {
      return [];
    }
    return models.map((e) {
      return DragAndDropItem(
        //ドラッグしてるときの様子
        // feedbackWidget: ,
        //PLAN:後回し
        child: ListTile(
          title: Text(
            e.name,
          ),
        ),
      );
    }).toList();
  }
}
