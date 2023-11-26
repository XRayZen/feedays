import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/page/search/search_recent_item.dart';
import 'package:feedays/ui/page/search_view_page.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_text_field.dart';

class SearchAutoComp extends ConsumerStatefulWidget {
  const SearchAutoComp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchAutoCompState();
}

class _SearchAutoCompState extends ConsumerState<SearchAutoComp> {
  @override
  Widget build(BuildContext context) {
    final recentList = ref.watch(recentSearchesProvider);
    var txt = 'Empty';
    return Autocomplete<String>(
      key: const Key('AutoCompField'),
      initialValue: TextEditingValue(text: ref.watch(searchTxtFieldProvider)),
      onSelected: (selectItem) {
        ref.watch(onTextFieldTapProvider.notifier).state = false;
        if (txt == '') {
          onSearch(
            SearchRequest(searchType: SearchType.keyword, word: txt),
            ref,
          );
        } else {
          onSearch(
            SearchRequest(searchType: SearchType.keyword, word: selectItem),
            ref,
          );
        }
      },
      //候補リストをカスタマイズ
      //それをすると履歴リストが自動で消えなくなる
      optionsViewBuilder: (context, onSelected, options) {
        return RecentViewWidget(list: options.toList(), onSelected: onSelected);
      },
      //テキストフィールドをカスタマイズ
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return CustomTextField(
          editingController: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            txt = value;
            onFieldSubmitted();
            //テキストフィールドの入力履歴を非表示にする
            ref.watch(visibleRecentViewProvider.notifier).state = false;
          },
        );
      },
      // 自動補完の動作を定義
      optionsBuilder: (textEditingValue) {
        //未入力なら履歴を表示させる
        if (textEditingValue.text == '') {
          return recentList;
        }
        //履歴を部分一致検索する
        return recentList
            .where((element) => element.contains(textEditingValue.text));
      },
    );
  }
}

///入力候補の見た目
class RecentViewWidget extends ConsumerWidget {
  const RecentViewWidget({
    super.key,
    required this.list,
    required this.onSelected,
  });
  final List<String> list;
  //候補Itemをカスタマイズする時は関数を返さなければならない
  final void Function(String) onSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleRecentViewProvider);
    return Visibility(
      visible: visible,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final txt = list.elementAt(index);
          //NOTE:候補Itemをカスタマイズする時はアイテムが選択された時の関数を返さなければならない
          return SearchRecentItem(txt: txt, onSelected: onSelected);
        },
      ),
    );
  }
}
