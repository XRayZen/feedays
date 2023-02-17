//複雑化したため、どのプロジェクトでも使い回せる検索ページを実装する
//NOTE:プロバイダーが使えなくなり動的に描画できなくなるのでやめておく
//コンストラクタで検索関数や結果を受け取るNotifierや結果アイテムビューWidgetを渡す

import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/widgets/search_view/result_view.dart';
import 'package:feedays/ui/widgets/search_view/search_auto_comp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///履歴リストを非表示するかしないか
final visibleRecentViewProvider = StateProvider<bool>((ref) {
  return true;
});

///テキストフィールドをタップしたかどうか
final onTextFieldTapProvider = StateProvider<bool>((ref) {
  return false;
});

enum SearchResultViewMode {
  result,
  none,

  ///テキストフィールド外をタップしたら結果ビューに半透明のウィジェットをかける
  shadow
}

final searchResultViewModeProvider = StateProvider<SearchResultViewMode>((ref) {
  return SearchResultViewMode.none;
});

class SearchViewPage extends ConsumerStatefulWidget {
  const SearchViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchViewPage> {
  @override
  Widget build(BuildContext context) {
    //https://qiita.com/taisei_dev/items/f4d22e1e17febc80cd79
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              titleSpacing: 5,
              title: const SearchAutoCompText(
                key: Key('SearchAutoCompText'),
              ),
              pinned: true,
              centerTitle: true,
              expandedHeight: 5,
              //バックしたら検索結果をクリアするため手動でバックボタンを実装する
              automaticallyImplyLeading: false,
              leading: SearchViewPageBackButton(
                ref: ref,
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('test'),
                )
              ],
            ),
          ];
        },
        body:
            // ignore: prefer_const_constructors
            CustomScrollView(
          slivers: const [
            ResultView(
              key: Key('ResultView'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchViewPageBackButton extends StatelessWidget {
  const SearchViewPageBackButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //テキストフィールドにタップしていたら履歴を非表示してリザルトモードにする
        if (ref.watch(onTextFieldTapProvider)) {
          ref.watch(searchResultViewModeProvider.notifier).state =
              SearchResultViewMode.result;
          ref.watch(visibleRecentViewProvider.notifier).state = false;
          ref.watch(onTextFieldTapProvider.notifier).state = false;
        } else {
          //バックしたら検索結果をクリア
          //リザルトタイプも元に戻す
          ref.watch(searchResultViewModeProvider.notifier).state =
              SearchResultViewMode.none;
          ref.watch(searchResultProvider.notifier).clear();
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
