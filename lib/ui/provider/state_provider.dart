import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFeedsEditModeProvider = StateProvider<FeedsEditMode>((ref) {
  return FeedsEditMode.noEdit;
});

final feedTypeProvider = StateProvider<FeedsType>((ref) {
  return FeedsType.all;
});

final selectedSiteProvider = StateProvider<String>((ref) {
  return "";
});

enum FeedsEditMode { edit, noEdit }
enum FeedsType { site, all }

