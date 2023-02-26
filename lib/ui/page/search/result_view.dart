import 'package:feedays/ui/page/search/result_list.dart';
import 'package:feedays/ui/page/search_paage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  bool isVisibleShadowWidget(SearchResultViewMode status) {
    switch (status) {
      case SearchResultViewMode.result:
        return false;
      case SearchResultViewMode.none:
        return false;
      case SearchResultViewMode.shadow:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(searchResultViewMode);
    //シャドウモードならリザルト画面にリザルト画面に半透明のウィジェットをかぶせる
    //shadowと無限スクロールをスタックさせる
    return SliverStack(
      insetOnOverlap: true,
      children: [
        const SearchResultList(key: Key('SearchResultList')),
        SliverPositioned.fill(
          child: ShadowWidget(
            visible: isVisibleShadowWidget(mode),
            key: const Key('ShadowWidget'),
          ),
        ),
      ],
    );
  }
}

class ShadowWidget extends ConsumerWidget {
  const ShadowWidget({required this.visible, super.key});
  final bool visible;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverVisibility(
      visible: visible,
      sliver: AnimatedOpacity(
        // 透明度の値を変数で指定
        opacity: 0.5,
        // アニメーションの時間を500ミリ秒に指定
        duration: const Duration(milliseconds: 500),
        // アニメーションのカーブをイーズインアウトに指定
        curve: Curves.easeInOut,
        // 青いコンテナを子ウィジェットとして指定
        child: Container(
          // width: 200,
          // height: 100,
          color: Colors.black,
        ),
      ),
    );
  }
}
