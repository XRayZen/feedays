import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/web_usecase.dart';
import 'package:feedays/infra/impl_repo/backend_repo_impl.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
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
  //PLAN:レポジトリもプロバイダー経由で渡したほうが良い
  //テスト用DIをする時に複雑にならない
  final webRepo = ref.watch(webRepoProvider);
  final apiRepo = ref.watch(backendApiRepoProvider);
  final userCOnfig = ref.watch(userConfigProvider);
  final webUsecase = WebUsecase(
    webRepo: webRepo,
    backendApiRepo: apiRepo,
    userCfg: userCOnfig,
  );
  return webUsecase;
});

///WebUsecaseの検索履歴を監視するプロバイダー
final recentSearchesProvider = Provider<List<String>>((ref) {
  //更新の条件を限定
  final use = ref
      .watch(webUsecaseProvider.select((value) => value.userCfg.searchHistory));
  return use;
});
