// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/search_view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return TextFormField(
      controller: editingController,
      focusNode: focusNode,
      autofocus: true,
      //遡ったら処理が見当たらないからカスタムしても良いかもしれない
      onFieldSubmitted: (value) {
        ref.watch(onTextFieldTapProvider.notifier).state = false;
        onFieldSubmitted();
        if (value.isEmpty) {
          editingController.clear();
        }
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
        //リザルトビューをシャドウモードにする
        ref.watch(searchResultViewModeProvider.notifier).state =
            SearchResultViewMode.shadow;
        ref.watch(visibleRecentViewProvider.notifier).state = true;
        ref.watch(onTextFieldTapProvider.notifier).state = true;
      },
      onTapOutside: (event) {
        //リザルトページにジェスチャーをおいてタップすれば消せるか→仕様上の制限で出来ない
        ref.watch(searchResultViewModeProvider.notifier).state =
            SearchResultViewMode.result;
      },
    );
  }
}
