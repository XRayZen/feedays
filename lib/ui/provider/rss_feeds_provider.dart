import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RssFeedsNotifier extends StateNotifier<List<FeedItem>> {
  RssFeedsNotifier() : super([]);
  void add(FeedItem feed) {
    state = [...state, feed];
  }

  void addList(List<FeedItem> sites) {
    // ステート自体もイミュータブルなため、`state.add(item)`
    // のような操作はできません。
    // 代わりに、既存と新規を含む新しいリストを作成します。
    // Dart のスプレッド演算子を使うと便利ですよ!
    //カテゴリーに基づいてノードを作る必要がある
    final n = state;
    n.addAll(sites);
    state = n;
    // `notifyListeners` などのメソッドを呼ぶ必要はありません。
    // `state =` により必要なときに UI側 に通知が届き、ウィジェットが更新されます。
  }

  void replace(List<FeedItem> sites) {
    state.clear();
    state = sites;
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
    StateNotifierProvider<RssFeedsNotifier, List<FeedItem>>((ref) {
  return RssFeedsNotifier();
});

//PLAN: お気に入りサイトリストはビジネスロジックにいずれ入れておく
final favSitesProvider = Provider<List<WebSite>>((ref) {
  return List.empty(growable: true);
});

//RSS取得状況を示すプログレスプロバイダー
final rssProgressProvider = StateProvider<double>((ref) {
  return 0.0;
});
