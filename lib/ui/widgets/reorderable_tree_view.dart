// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/ui/provider/notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReorderableTreeListView extends ConsumerStatefulWidget {
  const ReorderableTreeListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReorderableTreeListViewState();
}

class _ReorderableTreeListViewState
    extends ConsumerState<ReorderableTreeListView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: _buildTreeNodes(ref.watch(reorderableTreeListProvider)),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final TreeNode node =
              ref.watch(reorderableTreeListProvider).removeAt(oldIndex);
          ref.watch(reorderableTreeListProvider).insert(newIndex, node);
        });
      },
    );
  }

  List<Widget> _buildTreeNodes(List<TreeNode> nodes) {
    List<Widget> widgets = [];
    for (TreeNode node in nodes) {
      widgets.add(
        ExpansionTile(
          key: ValueKey(node.id),
          title: Text(node.title),
          children: _buildTreeNodes(node.children),
        ),
      );
    }
    return widgets;
  }
}

class TreeNode {
  final int id;
  final String title;
  final List<TreeNode> children;

  TreeNode({required this.id, required this.title, this.children = const []});
}
