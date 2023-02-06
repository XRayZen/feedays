import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/usecases/web_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userConfigProvider = Provider<UserConfig>((ref) {
  return UserConfig.defaultUserConfig();
});

final webUsecaseProvider = Provider<WebUsecase>((ref) {
  final webRepo = WebRepoImpl();
  final userCOnfig = ref.watch(userConfigProvider);
  final webUsecase = WebUsecase(repo: webRepo, user: userCOnfig);
  return webUsecase;
});
