import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFeedsEditModeProvider = StateProvider<FeedsEditMode>((ref) {
  return FeedsEditMode.noEdit;
});

final feedTypeProvider = StateProvider<FeedsType>((ref) {
  return FeedsType.all;
});

final selectedMainPageProvider = StateProvider<int>((ref) {
  return 0;
});

final barPageTypeProvider = StateProvider<PageType>((ref) => PageType.toDay);

enum PageType { readLater, toDay, addContent, powerSearch, searchView }

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
