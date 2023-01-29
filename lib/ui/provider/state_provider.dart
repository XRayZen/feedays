import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFeedsEditModeProvider = StateProvider<FeedsEditMode>((ref) {
  return FeedsEditMode.noEdit;
});

enum FeedsEditMode { edit, noEdit }
