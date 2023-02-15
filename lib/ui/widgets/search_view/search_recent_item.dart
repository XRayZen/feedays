// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedays/ui/provider/business_provider.dart';

class SearchRecentItem extends ConsumerWidget {
    const SearchRecentItem( {super.key, 
    required this.txt,
    required this.onSelected,
  });
  final String txt;
  //候補Itemをカスタマイズする時は関数を返さなければならない
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        ref
            .watch(webUsecaseProvider)
            .editRecentSearches(txt, isAddOrRemove: false);
      },
      //どんなに方向を変えても必ず左に配置されてしまう
      background: const Expanded(
        child: ColoredBox(
          color: Colors.red,
          child: Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: Card(
        child: ListTile(
          onTap: () => onSelected(txt),
          onLongPress: () {
            // TODO:長押しで削除するか小さな画面を出して尋ねる
          },
          title: Text(txt),
        ),
      ),
    );
  }
}
