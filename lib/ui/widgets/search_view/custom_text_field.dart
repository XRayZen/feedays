// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        //リザルトビューをシャドウモードにする
        ref.watch(SearchResultViewStatusProvider.notifier).state =
            SearchResultViewStatus.shadow;
      },
      onTapOutside: (event) {
        //ここで履歴リストを消す
        //BUG:タップしても反応ないから履歴削除機能は諦めるかもしれない
        //リザルトページにジェスチャーをおいてタップすれば消せるか
        ref.watch(SearchResultViewStatusProvider.notifier).state =
            SearchResultViewStatus.result;
        //TEST:RecentViewを消せるか試す
        ref.watch(visibleRecentViewProvider.notifier).state = false;
        final visibleRecentViewBool = ref.watch(visibleRecentViewProvider);
        print('visibleRecentViewProvider:{$visibleRecentViewBool}');
      },
    );
  }
}
