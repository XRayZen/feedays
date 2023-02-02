import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class rssFeedsNotifier extends StateNotifier<List<RssFeed>> {
  rssFeedsNotifier() : super([]);
  void add(RssFeed feed) {
    state = [...state, feed];
  }

  void addList(List<RssFeed> sites) {
    // ステート自体もイミュータブルなため、`state.add(item)`
    // のような操作はできません。
    // 代わりに、既存と新規を含む新しいリストを作成します。
    // Dart のスプレッド演算子を使うと便利ですよ!
    //カテゴリーに基づいてノードを作る必要がある
    var n = state;
    n.addAll(sites);
    state = n;
    // `notifyListeners` などのメソッドを呼ぶ必要はありません。
    // `state =` により必要なときに UI側 に通知が届き、ウィジェットが更新されます。
  }

  void removeOfLink(String link) {
    // しつこいですが、ステートはイミュータブルです。
    // そのため既存リストを変更するのではなく、新しくリストを作成する必要があります。
    final n = state;
    n.removeWhere((e) => e.link == link);
    state = n;
  }
}

final rssFeedsProvider =
    StateNotifierProvider<rssFeedsNotifier, List<RssFeed>>((ref) {
  return rssFeedsNotifier();
});
