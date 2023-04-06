import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/usecase.dart';
import 'package:feedays/infra/impl_repo/backend_repo_impl.dart';
import 'package:feedays/infra/impl_repo/local_repo_impl.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backendApiRepoProvider = Provider<BackendApiRepository>((ref) {
  //テスト時はモックに上書きする
  return BackendApiRepoImpl();
});

final webRepoProvider = Provider<WebRepositoryInterface>((ref) {
  return WebRepoImpl();
});

final localRepoProvider = Provider<LocalRepositoryInterface>((ref) {
  return LocalRepoImpl();
});

// final userConfigProvider = Provider<UserConfig>((ref) {
//   return UserConfig.defaultUserConfig();
// });

final useCaseProvider = Provider<Usecase>((ref) {
  Future<void> noticeError(String msg) async {
    //PLAN:エラー通知プロバイダーに送信
    //どう通知するかはプロバイダーで決める
  }
  Future<void> onAddSite(WebSite site) async {
    // TODO:UI側のプロバイダーを更新する
  }
  void progress(int count, int all, String msg) async {
    //UIに進捗を表示する
    ref.watch(rssProgressProvider.notifier).state = count / all;
  }

  return Usecase(
    webRepo: ref.watch(webRepoProvider),
    apiRepo: ref.watch(backendApiRepoProvider),
    localRepo: ref.watch(localRepoProvider),
    noticeError: noticeError,
    onAddSite: onAddSite,
    progressCallBack: progress,
  );
});

final appInitProvider = FutureProvider<void>((ref) async {
  await ref.watch(useCaseProvider).init();
});

///検索履歴を監視するプロバイダー
final recentSearchesProvider = Provider<List<String>>((ref) {
  //更新の条件を限定
  final use =
      ref.watch(useCaseProvider.select((value) => value.userCfg.searchHistory));
  return use;
});

///サーチテキストフィールドに入れておく文章
final searchTxtFieldProvider = StateProvider<String>((ref) {
  return '';
});

final subscribeWebSitesProvider = Provider<List<WebSiteFolder>>((ref) {
  final use = ref.watch(
    useCaseProvider.select((value) => value.userCfg.rssFeedSites.folders),
  );
  return use;
});
final readRssFolderProvider = Provider<List<WebSiteFolder>>((ref) {
  final res =
      ref.watch(useCaseProvider.select((v) => v.userCfg.rssFeedSites.folders));
  return res;
});

final readCategoriesProvider =
    FutureProvider<List<ExploreCategory>>((ref) async {
  final use = await ref.watch(rssUsecaseProvider).readCategories();
  return use;
});

bool anySiteOfRssFolders(String folderName, String siteUrl, WidgetRef ref) {
  final list = ref.watch(readRssFolderProvider);
  if (list.any((e) => e.name == folderName)) {
    final folder = list.where((element) => element.name == folderName).first;
    if (folder.children.any((element) => element.siteUrl == siteUrl)) {
      return true;
    }
  }
  return false;
}
