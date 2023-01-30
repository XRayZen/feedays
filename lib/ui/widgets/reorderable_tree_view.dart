import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:feedays/ui/model/feed_model.dart';
import 'package:feedays/ui/provider/subsc_sites_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
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
    var res = ref.watch(subscriptionSiteListProvider.notifier);
    //PLAN:このフラグがオンなら色々とアイコンの位置をずらす必要がある
    var isEditFlg = _isEditMode(ref.watch(isFeedsEditModeProvider));
    if (res.isEmpty()) {
      //PLAN:これをSilverToBoxで囲えばSliverでも高さ設定無し出来るか
      return const Center(child: Text('リストが空です'));
    } else {
      //カテゴリータイルにドラッグアンドドロップしたらそれを特定して
      //入れ替え処理を行う
      //編集モードの切替で右にメニューアイコンを表示させてドラッグ可能か判断できるようにする
      //NOTE:`DragAndDropLists`はページなら高さ設定は要らないが、ドロワーメニューでは高さ設定が必要
      return DragAndDropLists(
        children: _buildList(ref.watch(subscriptionSiteListProvider)),
        onItemReorder: _onChildItemReorder,
        onListReorder: _onListReorder,
        //trueの場合、長押しした後にアイテムをドラッグします。falseの場合は、すぐにドラッグします。
        itemDragOnLongPress: true,
        //リストのドラッグを長押しと短押しのどちらで行うかを指定します。
        //trueの場合、長押しの後にリストがドラッグされます。falseの場合、リストはすぐにドラッグされます。
        listDragOnLongPress: isEditFlg,
        //PLAN:いずれはスライバ(Sliver)を使うべき
        //ウィジェットまたはスライバと互換性のあるリストを返すかどうか。sliver として使用する場合は true を設定する。
        //true の場合、[scrollController] を提供する必要がある。ウィジェットのみで使用する場合は false に設定する。
        // sliverList: true,
        // scrollController: ScrollController(),
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

  _isEditMode(FeedsEditMode isMode) {
    return isMode == FeedsEditMode.edit ? true : false;
  }

  _buildDragHandle({bool isList = false, bool isEditMode = false}) {
    //位置がずれるのを直せた
    //参考:https://www.youtube.com/watch?v=HmiaGyf55ZM
    final alignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final handle = DragHandle(
      verticalAlignment: alignment,
      child: Container(
        padding: EdgeInsets.only(right: isList ? 0 : 10, top: isList ? 20 : 0),
        child: const Icon(Icons.menu),
      ),
    );
    print(isEditMode);
    return isEditMode ? handle : null;
  }

  //個別のアイテムの入れ替え
  _onChildItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    ref
        .watch(subscriptionSiteListProvider.notifier)
        .onItemReorder(oldItemIndex, oldListIndex, newItemIndex, newListIndex);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    ref
        .watch(subscriptionSiteListProvider.notifier)
        .onListReorder(oldListIndex, newListIndex);
  }

  _buildList(List<FeedModel> nodes) {
    List<DragAndDropListExpansion> widgets = [];

    for (var node in nodes) {
      widgets.add(DragAndDropListExpansion(
          //この項目がドラッグ可能かどうか。並べ替えが可能な場合は true を設定します。固定でなければならない場合はfalseに設定します。
          canDrag: _isEditMode(ref.watch(isFeedsEditModeProvider)),
          // initiallyExpanded: true,
          disableTopAndBottomBorders: false, //拡大時に上下に表示されるボーダーを無効化する。
          listKey: ObjectKey(node),
          title: Text(node.name),
          leading: const Icon(Icons.ac_unit),
          //feedlyを真似てアロートグルを右に寄せる
          //書き換えてもトグルスイッチの時にアニメコントローラーに指示しないと動かない
          // trailing: ExpansionTileCustomAnimeWidget(),
          onExpansionChanged: (bool value) {
            //コントローラーをステートプロバイダーにしてここで指示する
            // ref.watch(expansionTileCustomAnimePro);
          },
          children: _buildTreeChildNode(node.nodes)));
    }
    return widgets;
  }

  List<DragAndDropItem> _buildTreeChildNode(List<FeedModel> models) {
    if (models.isEmpty) {
      return [];
    }
    return models.map((e) {
      return DragAndDropItem(
        //ドラッグしてるときの様子
        // feedbackWidget: ,
        //PLAN:後回し
        //feedlyと同様タップしたらドロワーメニューを閉じてサイトのfeedPageにページを切り替える
        child: ListTile(
          title: Text(
            e.name,
          ),
        ),
      );
    }).toList();
  }
}

//他のクラスでも使いたいが渡す必要があるため渡せない
//StateNotifierでなら渡せる
//これ以上のプロバイダーコードはProviderレイヤーで書く
final expansionTileCustomAnimePro = Provider.autoDispose
    .family<AnimationController, _ExpansionTileAnimeState>((ref, lo) {
  return AnimationController(
      duration: const Duration(milliseconds: 900), vsync: lo);
});

class ExpansionTileCustomAnimeWidget extends ConsumerStatefulWidget {
  const ExpansionTileCustomAnimeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpansionTileAnimeState();
}

class _ExpansionTileAnimeState
    extends ConsumerState<ExpansionTileCustomAnimeWidget>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);
  // late final AnimationController _controller;
  late Animation<double> _iconTurns;
  @override
  void initState() {
    super.initState();
    final controller = ref.read(expansionTileCustomAnimePro(this));
    _iconTurns = controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }
}
