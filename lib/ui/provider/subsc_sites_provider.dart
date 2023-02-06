import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/model/subsc_feed_site_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionSiteListNotifier
    extends StateNotifier<List<SubscFeedSiteModel>> {
  SubscriptionSiteListNotifier() : super([]);

  //追加
  void add(List<WebSite> sites) {
    // ステート自体もイミュータブルなため、`state.add(item)`
    // のような操作はできません。
    // 代わりに、既存と新規を含む新しいリストを作成します。
    // Dart のスプレッド演算子を使うと便利ですよ!
    //カテゴリーに基づいてノードを作る必要がある
    List<SubscFeedSiteModel> items = _webSitesToFeedModels(sites);
    if (state.isEmpty) {
      state = items;
    } else {
      var list = state;
      list.addAll(items);
      state = list;
    }
    // `notifyListeners` などのメソッドを呼ぶ必要はありません。
    // `state =` により必要なときに UI側 に通知が届き、ウィジェットが更新されます。
  }

  //入れ替えの場合はリストをコピーしてそのリストから入れ替え処理してリストを新規作成する
  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    const point = 0;
    final newList = [...state];
    final SubscFeedSiteModel movedItem =
        newList[oldListIndex + point].nodes.removeAt(oldItemIndex);
    newList[newListIndex].nodes.insert(newItemIndex, movedItem);
    //TODO:ビジネスロジックにも反映させる
    //NOTE:別のカテゴリに移動したらそれも検知する
    final oldCategory = newList[oldListIndex + point].category;
    final newCategory = newList[newListIndex].category;
    final movedItmeKey = movedItem.url;
    state = newList;
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    final newList = [...state];
    if (oldListIndex < newListIndex) {
      newListIndex -= 1;
    }
    final node = newList.removeAt(oldListIndex);
    newList.insert(newListIndex, node);
    state = newList;
  }

  void deleteOfWebSite(WebSite site) {
    // 既存のstateからsiteを持つFeedModelオブジェクトを探す
    final feedModel =
        state.firstWhere((feedModel) => feedModel.name == site.name);
    // 既存のstateからfeedModelを除外した新しいリストを作成
    final newList =
        state.where((feedModel) => feedModel.name != site.name).toList();
    // stateに新しいリストを代入
    state = newList;
  }

  void deleteOfFeedModel(SubscFeedSiteModel model) {
    state = [...state.where((item) => item != model)];
  }

  bool isEmpty() {
    return state.isEmpty;
  }
}

final subscriptionSiteListProvider = StateNotifierProvider<
    SubscriptionSiteListNotifier, List<SubscFeedSiteModel>>((ref) {
  return SubscriptionSiteListNotifier();
});

List<SubscFeedSiteModel> _webSitesToFeedModels(List<WebSite> sites) {
  var items = <SubscFeedSiteModel>[];
  int currentCategoryKey = 7000;
  for (var site in sites) {
    if (items.isEmpty) {
      items.add(SubscFeedSiteModel(
          key: currentCategoryKey.toString(),
          name: site.category,
          url: "",
          newCount: 0,
          category: site.category,
          categoryOrSite: CategoryOrSite.category,
          nodes: [SubscFeedSiteModel.from(site)]));
    }
    if (items.any((element) => element.category == site.category)) {
      //Nodeを追加する
      var findCategoryIndex =
          items.indexWhere((element) => site.category == element.category);
      items[findCategoryIndex].nodes.add(SubscFeedSiteModel.from(site));
    } else {
      //カテゴリーを追加
      currentCategoryKey += 1 + items.length;
      items.add(SubscFeedSiteModel(
          key: currentCategoryKey.toString(),
          name: site.category,
          url: "",
          newCount: 0,
          category: site.category,
          categoryOrSite: CategoryOrSite.category,
          nodes: [SubscFeedSiteModel.from(site)]));
    }
  }
  return items;
}
