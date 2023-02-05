import 'package:feedays/domain/usecases/web_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webUsecaseProvider = Provider<WebUsecase>((ref) {
  final webUsecase = WebUsecase(repo: WebRepoImpl());
  return webUsecase;
});
