import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final visibleTextProvider = StateProvider<bool>((ref) {
  return true;
});

final visibleRecentTextProvider = StateProvider<bool>((ref) {
  return true;
});

final isFeedsEditModeProvider = StateProvider<FeedsEditMode>((ref) {
  return FeedsEditMode.noEdit;
});

final feedTypeProvider = StateProvider<FeedsType>((ref) {
  return FeedsType.all;
});

final selectedMainPageProvider = StateProvider<int>((ref) {
  return 0;
});


enum RecentOrResult{recent,result}

final recentOrResultProvider = StateProvider<RecentOrResult>((ref) {
  return RecentOrResult.recent;
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
        (ref) => SelectedSiteNotifier(),);

enum FeedsEditMode { edit, noEdit }

enum FeedsType { site, all, trend, today }
