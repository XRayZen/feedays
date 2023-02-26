// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/page/search_paage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSearchTxtClearBtn = StateProvider<bool>((ref) {
  return false;
});
final isSearchTxtAutoFocus = StateProvider<bool>((ref) {
  return true;
});

class CustomTextField extends ConsumerWidget {
  final TextEditingController editingController;
  final FocusNode focusNode;
  final VoidCallback onFieldSubmitted;
  const CustomTextField({
    super.key,
    required this.editingController,
    required this.focusNode,
    required this.onFieldSubmitted,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        TextFormField(
          controller: editingController,
          focusNode: focusNode,
          autofocus: ref.watch(isSearchTxtAutoFocus),
          //遡ったら処理が見当たらないからカスタムしても良いかもしれない
          onFieldSubmitted: (value) {
            ref.watch(onTextFieldTapProvider.notifier).state = false;
            onFieldSubmitted();
            if (value.isEmpty) {
              editingController.clear();
            }
            //入れておかないと入力候補第一位が入れられてしまう
            editingController.text = value;
            onSearch(
              SearchRequest(searchType: SearchType.addContent, word: value),
              ref,
            );
          },
          onChanged: (value) {
            if (value.isEmpty) {
              ref.watch(isSearchTxtClearBtn.notifier).state = false;
            } else {
              ref.watch(isSearchTxtClearBtn.notifier).state = true;
            }
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
            //リザルトビューをシャドウモードにする
            ref.watch(searchResultViewMode.notifier).state =
                SearchResultViewMode.shadow;
            ref.watch(visibleRecentViewProvider.notifier).state = true;
            ref.watch(onTextFieldTapProvider.notifier).state = true;
            if (editingController.text.isNotEmpty) {
              ref.watch(isSearchTxtClearBtn.notifier).state = true;
            }
          },
          onTapOutside: (event) {
            //リザルトページにジェスチャーをおいてタップすれば消せるか→仕様上の制限で出来ない
            ref.watch(searchResultViewMode.notifier).state =
                SearchResultViewMode.result;
          },
        ),
        //テキストをタップしてフィールドに文字があったらフィールドの上にクリアボタンを置く
        ClearButton(
          editingController: editingController,
        ),
      ],
    );
  }
}

class ClearButton extends ConsumerWidget {
  const ClearButton({
    super.key,
    required this.editingController,
  });

  final TextEditingController editingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClearButton = ref.watch(isSearchTxtClearBtn);
    return Visibility(
      visible: isClearButton,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IconButton(
            onPressed: () {
              ref.watch(searchResultViewMode.notifier).state =
                  SearchResultViewMode.shadow;
              ref.watch(visibleRecentViewProvider.notifier).state = true;
              ref.watch(onTextFieldTapProvider.notifier).state = true;
              editingController.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
