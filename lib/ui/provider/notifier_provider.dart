import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/model/feed_model.dart';
import 'package:feedays/ui/widgets/reorderable_tree_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reorderableTreeListProvider = Provider<List<TreeNode>>((ref) => []);

class FeedsListNotifier extends StateNotifier<List<FeedModel>> {
  FeedsListNotifier() : super([]);

  //追加
  void add(WebSite site) {
    // ステート自体もイミュータブルなため、`state.add(item)`
    // のような操作はできません。
    // 代わりに、既存と新規を含む新しいリストを作成します。
    // Dart のスプレッド演算子を使うと便利ですよ!
    state = [...state, FeedModel.from(site)];
    // `notifyListeners` などのメソッドを呼ぶ必要はありません。
    // `state =` により必要なときに UI側 に通知が届き、ウィジェットが更新されます。
  }
  //PLAN:入れ替えの場合はリストをコピーしてそのリストから入れ替え処理してリストを新規作成する

}
