//複雑化したため、どのプロジェクトでも使い回せる検索ページを実装する
//TODO:プロバイダーが使えなくなり動的に描画できなくなるのでやめておく
//コンストラクタで検索関数や結果を受け取るNotifierや結果アイテムビューWidgetを渡す

import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/saerch_vm.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/search_view/result_view.dart';
import 'package:feedays/ui/widgets/search_view/search_auto_comp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchViewPage extends ConsumerStatefulWidget {
  const SearchViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchViewPage> {
  @override
  Widget build(BuildContext context) {
    //TODO:重要な点はテキストフィールドの履歴表示の切り替え
    //https://qiita.com/taisei_dev/items/f4d22e1e17febc80cd79
    //_SearchTextField から作り変える
    //ページ全体を作り変えるのでScaffoldから始める
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
            ),
            //TODO:検索結果を表示するViewも新しく作り変える
            //TODO:テキストフィールドをタップしたらリザルト画面に半透明のウィジェットをかぶせて
            //それへのタップで履歴リストを非表示する
            // ignore: prefer_const_constructors
            ResultView(
              key: const Key('ResultView'),
            )
          ];
        },
        //ここに表示する予定はない
        body: const SizedBox(),
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
        //バックしたら検索結果をクリア
        //リザルトタイプも元に戻す
        ref.watch(visibleRecentTextProvider.notifier).state = true;
        ref.watch(SearchResultViewStatusProvider.notifier).state =
            SearchResultViewStatus.none;
        ref.watch(searchResultProvider.notifier).clear();
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
