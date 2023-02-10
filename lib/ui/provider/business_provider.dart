import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/web_usecase.dart';
import 'package:feedays/infra/impl_repo/backend_repo_impl.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backendApiRepoProvider = Provider<BackendApiRepository>((ref) {
  //テスト時はモックに上書きする
  return BackendApiRepoImpl();
});

final webRepoProvider = Provider<WebRepositoryInterface>((ref) {
  return WebRepoImpl();
});

final userConfigProvider = Provider<UserConfig>((ref) {
  return UserConfig.defaultUserConfig();
});

final webUsecaseProvider = Provider<WebUsecase>((ref) {
  //テスト用DIをする時に複雑にならない
  final webRepo = ref.watch(webRepoProvider);
  final apiRepo = ref.watch(backendApiRepoProvider);
  final userCOnfig = ref.watch(userConfigProvider);
  Future<void> noticeError(String msg) async {
    //PLAN:エラー通知プロバイダーに送信
    //どう通知するかはプロバイダーで決める
  }
  final webUsecase = WebUsecase(
    webRepo: webRepo,
    backendApiRepo: apiRepo,
    userCfg: userCOnfig,
    noticeError: noticeError,
  );
  return webUsecase;
});

final searchProvider = FutureProvider<SearchResult>((
  ref,
) async {
  //検索notifierを監視する
  //BUG:検索リクエストしても変化しない/来ない
  final req = ref.watch(searchRequestProvider);
  late SearchRequest request;
  req.whenData((value) => request = value);
  final result = await ref.watch(webUsecaseProvider).searchWord(request);
  //テキストフィールドをタップしたら元に戻す
  ref.watch(recentOrResultProvider.notifier).state = RecentOrResult.result;
  return result;
});

///WebUsecaseの検索履歴を監視するプロバイダー
final recentSearchesProvider = Provider<List<String>>((ref) {
  //更新の条件を限定
  final use = ref
      .watch(webUsecaseProvider.select((value) => value.userCfg.searchHistory));
  return use;
});
