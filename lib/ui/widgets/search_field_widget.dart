import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const searchDelayMillSec = 1000;
DateTime _lastChangedDate = DateTime.now();

class SearchFieldWidget extends ConsumerWidget {
  const SearchFieldWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchTextFieldControllerProvider);
    return TextFormField(
      key:const Key('SearchTextFormField'),
      controller: controller,
      autofocus: true,
      onFieldSubmitted: (txt) {
        //PLAN:入力履歴はローカル・クラウド両方に保存しておく
        //プロバイダーにテキストを送信して処理をする
        final req = SearchRequest(searchType: SearchType.addContent, word: txt);
        onSearch(req, ref);
      },
      onChanged: (val) => onChangedSearch(val, ref),
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
    );
  }

  void onChangedSearch(String txt, WidgetRef ref) {
    //NOTE:入力されるたびに呼び出されたら都度検索して候補を提示する
    //ユーザーが入力し終えたら検索処理をするという実装
    //検索検索が正常に返ったらモードを切り替えて結果を表示する
    //この場合は遅延処理をしてしばらくしたら検索する方式
    Future.delayed(const Duration(milliseconds: searchDelayMillSec), () {
      final nowDate = DateTime.now();
      if (nowDate.difference(_lastChangedDate).inMilliseconds >
          searchDelayMillSec) {
        _lastChangedDate = nowDate;
        //ここから直接サーチを実行するのではなくStateProviderに検索キーワードを入れて検索を実行
        final req = SearchRequest(searchType: SearchType.addContent, word: txt);
        onSearch(req, ref);
      }
    });
    //キーワードが入力されるごとに、検索処理を待たずに_lastChangedDateを更新する
    _lastChangedDate = DateTime.now();
  }
}
