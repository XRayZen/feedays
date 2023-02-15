import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visibleRecentViewProvider = StateProvider<bool>((ref) {
  return true;
});

///TODO:このプロバイダーの処理がややこしいからUI側では変更せずプロバイダー側でのみ変更する


final isFeedsEditModeProvider = StateProvider<FeedsEditMode>((ref) {
  return FeedsEditMode.noEdit;
});

final feedTypeProvider = StateProvider<FeedsType>((ref) {
  return FeedsType.all;
});

final selectedMainPageProvider = StateProvider<int>((ref) {
  return 0;
});

enum SearchResultViewStatus {
  result,
  none,
  ///テキストフィールド外をタップしたら結果ビューに半透明のウィジェットをかける
  shadow
}

final SearchResultViewStatusProvider =
    StateProvider<SearchResultViewStatus>((ref) {
  return SearchResultViewStatus.none;
});

final pageTypeProvider = StateProvider<PageType>((ref) => PageType.toDay);

enum PageType {
  readLater,
  toDay,
  addContent,
  search,
}

class SelectedSiteNotifier extends StateNotifier<WebSite> {
  SelectedSiteNotifier() : super(WebSite.mock("", "name", "category"));
  void selectSite(WebSite webSite) {
    state = webSite;
  }

  WebSite read() {
    return state;
  }
}

final selectWebSiteProvider =
    StateNotifierProvider<SelectedSiteNotifier, WebSite>(
  (ref) => SelectedSiteNotifier(),
);

enum FeedsEditMode { edit, noEdit }

enum FeedsType { site, all, trend, today }
