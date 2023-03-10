import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/page/search/list_item/rss_feed_item_ui.dart';
import 'package:feedays/ui/page/search/list_item/site_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultList extends ConsumerStatefulWidget {
  const SearchResultList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultSliverState();
}

class _ResultSliverState extends ConsumerState<SearchResultList> {
  int count(SearchResult res) {
    if (res.articles.isNotEmpty) {
      return res.articles.length;
    } else {
      return res.websites.length;
    }
  }

  //検索結果リストのアイテムUI
  Widget item(SearchResult res, int index) {
    //試しに切り替える
    switch (res.searchType) {
      case SearchType.addContent:
        return SiteListItem(
          site: res.websites[index],
        );
      case SearchType.powerSearch:
        return RssFeedItemUI(
          index: index,
          articles: res.articles,
        );
      case SearchType.exploreWeb:
        return SiteListItem(
          site: res.websites[index],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    //NOTE:無限スクロールでは負担軽減だが検索フロー全体をリファクタしなければならないので
    //一旦Sliverにしておく
    final res = ref.watch(searchResultProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return item(res, index);
        },
        childCount: count(res),
      ),
    );
  }
}
