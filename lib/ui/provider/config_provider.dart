import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AppCfgProvider = Provider<AppConfig>((ref) {
  return ref.watch(useCaseProvider.select((value) => value.userCfg.appConfig));
});
