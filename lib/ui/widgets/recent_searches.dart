import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentSearchesListView extends ConsumerStatefulWidget {
  const RecentSearchesListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecentSearchesListViewState();
}

class _RecentSearchesListViewState
    extends ConsumerState<RecentSearchesListView> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(recentSearchesProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final txt = list[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                ref
                    .watch(webUsecaseProvider)
                    .editRecentSearches(txt, isAddOrRemove: false);
              });
            },
            //どんなに方向を変えても必ず左に配置されてしまう
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Padding(padding: EdgeInsets.all(10)),
                  Icon(Icons.delete_sweep, color: Colors.white),
                  Padding(padding: EdgeInsets.all(5)),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            child: ListTile(
              onTap: () {
                // テキストフィールドのコントローラーからテキストを入れて検索
                ref.watch(searchTextFieldControllerProvider).text = txt;
                //UIを検索結果にもとづいて切り替えるためプロバイダーにキーワードを一旦入れておく
                onSearch(
                  SearchRequest(searchType: SearchType.addContent, word: txt),
                  ref,
                );
              },
              title: Text(txt),
            ),
          );
        },
        childCount: list.length,
      ),
    );
  }
}
