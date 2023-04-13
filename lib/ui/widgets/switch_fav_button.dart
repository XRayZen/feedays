// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchFavorite extends ConsumerStatefulWidget {
  final WebSite site;
  const SwitchFavorite({
    super.key,
    required this.site,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchFavoriteState();
}

class _SwitchFavoriteState extends ConsumerState<SwitchFavorite> {
  @override
  Widget build(BuildContext context) {
    if (ref
        .watch(favSitesProvider)
        .any((element) => element.siteUrl == widget.site.siteUrl)) {
      return IconButton(
        tooltip: 'Tap to remove from favorites.',
        onPressed: () {
          setState(() {
            ref.watch(favSitesProvider).removeWhere(
                  (element) => element.siteUrl == widget.site.siteUrl,
                );
            ref.watch(onChangedProvider.notifier).state += 1;
          });
        },
        color: Colors.pink,
        icon: Row(
          children: const [
            Icon(Icons.star),
            Padding(padding: EdgeInsets.all(5)),
            Text('Remove Favorite'),
          ],
        ),
      );
    } else {
      return IconButton(
        tooltip: 'Add Favorite',
        onPressed: () async {
          //お気に入り登録
          setState(() {
            ref.watch(favSitesProvider).add(widget.site);
            ref.watch(onChangedProvider.notifier).state += 1;
          });
        },
        icon: Row(
          children: const [
            Icon(Icons.star_border),
            Padding(padding: EdgeInsets.all(5)),
            Text('Add Favorite'),
          ],
        ),
      );
    }
  }
}
