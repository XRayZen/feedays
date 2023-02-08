import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            background: ColoredBox(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: const [
                    Text('delete', style: TextStyle(color: Colors.white)),
                    Icon(Icons.delete_sweep, color: Colors.white),
                  ],
                ),
              ),
            ),
            child: ListTile(title: Text(txt)),
          );
        },
        childCount: list.length,
      ),
    );
  }
}
