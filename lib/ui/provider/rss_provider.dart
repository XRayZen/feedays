import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/usecase/rss_usecase.dart';
import 'package:feedays/ui/page/search_view_page.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/saerch_vm.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rssUsecaseProvider = Provider<RssUsecase>((ref) {
  final rssUsecase = ref.watch(useCaseProvider).rssUsecase;
  return rssUsecase;
});

final readWebSiteProvider =
    FutureProvider.autoDispose.family<WebSite, WebSite>((ref, site) async {
  //最初にデータを読み込んで無いのなら更新する
  //ここら辺のロジックはビジネスロジックなので移す
  return ref.watch(rssUsecaseProvider).readRssFeed(site);
});

void onSearch(SearchRequest request, WidgetRef ref) {
  //空の文字は検索しない
  if (request.word.isEmpty) {
    //TODO:空の文字の場合はスナックバーでエラー警告を出す
  }
  ref.watch(searchProvider(request));
}

final searchProvider = FutureProvider.autoDispose.family<void, SearchRequest>((
  ref,
  request,
) async {
  // このプロバイダーに引数をつけて実行して結果を
  //notifierに入れてからモードを切り替える方式を試す
  late SearchResult result;
  try {
    //TODO:ここでダイアログを出して進捗を出す
    result = await ref.watch(rssUsecaseProvider).searchWord(request);
  } on Exception catch (e) {
    result = SearchResult(
      apiResponse: ApiResponseType.refuse,
      responseMessage: e.toString(),
      resultType: SearchResultType.error,
      searchType: request.searchType,
      websites: [],
      articles: [],
    )..exception = e;
  }

  ref.watch(searchResultViewMode.notifier).state = SearchResultViewMode.result;
  //resultなら消しておく
  ref.watch(visibleRecentTextProvider.notifier).state = false;
  //結果をnotifierに入れる
  ref.watch(searchResultProvider.notifier).add(result);
  // return result;
});
