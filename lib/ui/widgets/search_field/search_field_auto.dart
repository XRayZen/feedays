// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/search_view/search_recent_item.dart';

class SearchTextAutoCompField extends ConsumerWidget {
  const SearchTextAutoCompField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentList = ref.watch(recentSearchesProvider);

    //https://qiita.com/taisei_dev/items/f4d22e1e17febc80cd79
    return Autocomplete<String>(
      //自動補完の動作を定義
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == '') {
          // 未入力の場合は自動補完を走らせない
          //だが今回は未入力なら履歴を表示させる
          return recentList;
        }
        //履歴を部分一致検索する
        return recentList
            .where((element) => element.contains(textEditingValue.text));
      },
      //自動補完を選択
      onSelected: (selectTxt) {
        //UIを検索結果にもとづいて切り替えるためプロバイダーにキーワードを一旦入れておく
        onSearch(
          SearchRequest(searchType: SearchType.addContent, word: selectTxt),
          ref,
        );
      },
      //候補リストをカスタマイズ
      //それをすると履歴リストが自動で消えなくなる
      optionsViewBuilder: (context, onSelected, options) {
        return RecentViewWidget(
          list: options.toList(),
          onSelected: onSelected,
        );
      },
      //テキストフィールドをカスタマイズ
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        //この時にコントローラーをプロバイダーに入れて共有しておく
        return buildCustomTextfieldView(
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
          ref,
        );
      },
    );
  }

  Widget buildCustomTextfieldView(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
    WidgetRef ref,
  ) {
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      autofocus: true,
      //遡ったら処理が見当たらないからカスタムしても良いかもしれない
      onFieldSubmitted: (value) {
        onFieldSubmitted();
        onSearch(
          SearchRequest(searchType: SearchType.addContent, word: value),
          ref,
        );
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(Icons.search),
        //今はURLしか機能しない
        //その他はクラウド機能で実現
        hintText: 'Type a name, topic, or paste a URL',
      ),
      onTap: () {
        ref.watch(visibleRecentViewProvider.notifier).state = true;
        //TODO:テキストフィールドをタップしたらリザルト画面に半透明のウィジェットをかぶせて
        //それへのタップで履歴リストを非表示する
      },
      onTapOutside: (event) {
        //ここでなら履歴リストは消せるが同様の問題が起きそう
        //BUG:タップしても反応ないから履歴削除機能は諦めるかもしれない
        //リザルトページにジェスチャーをおいてタップすれば消せるか
        ref.watch(visibleRecentViewProvider.notifier).state = false;
      },
      // onEditingComplete: () {},
    );
  }
}

class RecentViewWidget extends ConsumerWidget {
  final List<String> list;
  //候補Itemをカスタマイズする時は関数を返さなければならない
  final void Function(String) onSelected;
  const RecentViewWidget({
    super.key,
    required this.list,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isvisible = ref.watch(visibleRecentViewProvider);
    return Visibility(
      //TODO:履歴リストの外をタップすれば消す
      //消えないしテキストフィールドに履歴リスト抹消
      visible: isvisible,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final txt = list.elementAt(index);
          //NOTE:候補Itemをカスタマイズする時はアイテムが選択された時の関数を返さなければならない
          return SearchRecentItem(txt: txt, onSelected: onSelected);
          // MyWidget(txt: recentList[index]);
        },
      ),
    );
  }
}
