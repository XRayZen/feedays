// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feedays/ui/provider/state_provider.dart';

class FeedList extends ConsumerStatefulWidget {
  const FeedList({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedListState();
}

class _FeedListState extends ConsumerState<FeedList> {
  @override
  Widget build(BuildContext context) {
    //サイトが選択もしくはAllが選択されたらビジネスロジックを呼んでサイトのフィードを取得してリストに追加して表示する
    //flutterのビジネスロジックインスタンス・依存性注入のやり方が分かったら再開できるか
    //リストはパッケージのinfinite_scroll_paginationを使う
    //これで遅延読み込みを習得する
    var feeds = ref.watch(rssFeedsProvider);
    return Container();
  }
}
