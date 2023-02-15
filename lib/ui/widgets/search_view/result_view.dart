import 'dart:ffi';

import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  Future<void> fetch() async {

  }

  @override
  Widget build(BuildContext context) {
    //TODO:検索フローで結果が帰ってくる件数に上限を設けていない問題　リソースが浪費される
    //パフォーマンスを上げるためにスライバーリストの無限スクロールで
    //無限スクロールだとStateNotifierではなくFutureProviderで対応できる
    //TODO:テキストフィールドをタップしたらリザルト画面に半透明のウィジェットをかぶせて
    //それへのタップで履歴リストを非表示する
    final mode = ref.watch(SearchResultViewStatusProvider);
    final res = ref.watch(searchResultProvider);
    //シャドウモードならリザルト画面にリザルト画面に半透明のウィジェットをかぶせる
    //それをジェスチャーディテクターをラップする
    return Container();
    
  }
}
