import 'package:feedays/domain/entities/web_sites.dart';
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

final barViewTypeProvider =
    StateProvider<TabBarViewType>((ref) => TabBarViewType.addContent);

enum TabBarViewType {
  readLater,
  toDay,
  addContent,
  powerSearch,
  searchView,
  siteDetail
}

class SelectedSiteNotifier extends StateNotifier<WebSite> {
  SelectedSiteNotifier() : super(WebSite.mock('', 'name', 'category'));
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
