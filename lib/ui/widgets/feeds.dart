import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feeds extends ConsumerStatefulWidget {
  const Feeds({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedsState();
}

class _FeedsState extends ConsumerState<Feeds> {
  List<Model> modelList = [];
  void _onOrder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // 移動前のインデックスより移動後のインデックスが大きい場合、アイテムの長さがリストの保有数よりも1大きくなってしまうため、
      // newIndexから1引きます。
      // 例えば、上の画像のように1番目のアイテムを3番目に移動した場合、oldIndex = 0, newIndex = 3となります。
      // newIndexを1引いて2とします。
      //
      newIndex -= 1;
    }
    // 0番目のアイテムをリストから出します
    final Model model = modelList.removeAt(oldIndex);
    setState(() {
      // index = 2にアイテムを挿入します
      modelList.insert(newIndex, model);
    });
  }

  @override
  void initState() {
    super.initState();
    modelList = [];
    List<String> titleList = ["Title A", "Title B", "Title C"];
    List<String> subTitleList = ["SubTitle A", "SubTitle B", "SubTitle C"];
    for (int i = 0; i < 3; i++) {
      Model model = Model(
        title: titleList[i],
        subTitle: subTitleList[i],
        key: i.toString(),
      );
      modelList.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
        buildDefaultDragHandles: ref.watch(isFeedsEditModeProvider),
        onReorder: _onOrder,
        //TODO:ツリー出来るリストを作る
        //TODO:StateNotifierを監視してリストを生成
        children: modelList.map((Model model) {
          return Card(
            elevation: 2.0,
            key: Key(model.key),
            child: ListTile(
              leading: const Icon(Icons.people),
              title: Text(model.title),
              subtitle: Text(model.subTitle),
            ),
          );
        }).toList());
  }
}

class Model {
  final String title;
  final String subTitle;
  final String key;
  Model({
    required this.title,
    required this.subTitle,
    required this.key,
  });
}
