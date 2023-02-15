import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/search_view/search_recent_item.dart';
import 'package:feedays/ui/widgets/search_view/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchAutoCompText extends ConsumerStatefulWidget {
  const SearchAutoCompText({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchAutoCompState();
}

class _SearchAutoCompState extends ConsumerState<SearchAutoCompText> {
  //TODO:ここも新しく作り変える
  @override
  Widget build(BuildContext context) {
    final recentList = ref.watch(recentSearchesProvider);
    return Autocomplete<String>(
      key: const Key('AutoCompField'),
      onSelected: (selectItem) {
        onSearch(
          SearchRequest(searchType: SearchType.addContent, word: selectItem),
          ref,
        );
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
          onFieldSubmitted: onFieldSubmitted,
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
