import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/provider/saerch_vm.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/indicator/no_more_item_indicator.dart';
import 'package:feedays/ui/widgets/search_field/search_field_auto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebSites extends ConsumerWidget {
  const WebSites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //NOTE:feedlyではWebSitesにのみピンされたテキストフィールドがあるが、
    //細かな再現には時間がかかりすぎるからそこまで求めない
    //NOTE:若干feedlyとUI動作は異なるが速度優先で仕上げる
    final con = TextEditingController();
    return Column(
      key: const Key('WebsitesColumn'),
      children: [
        TextFormField(
          key: const Key('SearchTextFieldTap'),
          controller: con,
          onChanged: (value) {
            con.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                // ignore: prefer_const_constructors
                builder: (context) => _SearchTextField(),
              ),
            );
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // ignore: prefer_const_constructors
                builder: (context) => _SearchTextField(),
              ),
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
            //フォームの横にアイコンを表示
            icon: const Icon(Icons.search),
            //今はURLしか機能しない
            //その他はクラウド機能で実現
            hintText: 'Type a name, topic, or paste a URL',
          ),
        ),
        //PLAN:カテゴリごとにおすすめが配置されている
        //NOTE:おすすめはクラウド上にリクエストして表示する必要があるがVer1では実装しない
      ],
    );
  }
}

class _SearchTextField extends ConsumerStatefulWidget {
  const _SearchTextField();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __SearchTextFieldState();
}

class __SearchTextFieldState extends ConsumerState<_SearchTextField> {
  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(visibleRecentTextProvider);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            //ページをバックしたら検索結果をクリアする
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              titleSpacing: 5,
              title:
                  const SearchTextAutoCompField(key: Key('SearchFieldWidget')),
              pinned: true,
              centerTitle: true,
              expandedHeight: 5,
              //バックしたら検索結果をクリアするため手動でバックボタンを実装する
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  //バックしたら検索結果をクリア
                  //リザルトタイプも元に戻す
                  ref.watch(visibleRecentTextProvider.notifier).state = true;
                  ref.watch(SearchResultViewStatusProvider.notifier).state =
                      SearchResultViewStatus.none;
                  ref.watch(searchResultProvider.notifier).clear();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(10)),
            //ここから下は履歴か検索結果を切り替えて表示する
            //入力フォームの下に入力履歴がスライドしたらリムーブするリストタイルが縦で羅列している
            // 切り替えは関数化して個別Widgetはクラス化して描画を細かく分ける
            const RecentOrResultView(),
          ];
        },
        body: const SizedBox(),
      ),
    );
  }
}

class RecentOrResultView extends ConsumerWidget {
  const RecentOrResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //先に履歴か検索結果かのモードを入れておいたほうが良いか
    final mode = ref.watch(SearchResultViewStatusProvider);
    return _recentOrResultWidget(mode, ref);
  }

  Widget _recentOrResultWidget(SearchResultViewStatus result, WidgetRef ref) {
    switch (result) {
      case SearchResultViewStatus.result:
        //resultなら消しておく
        // ref.watch(visibleRecentTextProvider.notifier).state = false;
        return const SearchResultView();
      case SearchResultViewStatus.shadow:
        return const SearchResultView();
      case SearchResultViewStatus.none:
        return const SliverToBoxAdapter(
          child: SizedBox(),
        );
    }
  }
}

class SearchResultView extends ConsumerWidget {
  const SearchResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ここから下は履歴か検索結果を切り替えて表示する
    final res = ref.watch(searchResultProvider);
    //デフォルトはリザルトタイプがnoneだからそれに応じたuiにしてアクセプトにしたら変える
    return howResult(res);
  }

  Widget howResult(PreSearchResult res) {
    switch (res.resultType) {
      case SearchResultType.found:
        return _buildSearchResultList(res);
      case SearchResultType.none:
        //初期状態
        //NOTE:本当なら読み込み中と初期状態に分けたい
        return const SliverToBoxAdapter(
          child: NoMoreItemIndicator(),
        );
      case SearchResultType.error:
        //PLAN:exceptionも出力する予定
        return SliverToBoxAdapter(
          child: ListTile(title: Text(res.exception.toString())),
        );
    }
  }

  ///TODO:ここで非同期プロバイダーで再現する
  ///TODO:非同期でリクエストするから出来るのならFutureかAsyncNotifierProviderで監視したい
  void howAsyncResult(AsyncValue<PreSearchResult> res) {}

  void methodName() {}

  Widget _buildSearchResultList(PreSearchResult res) {
    late final int searchResultLength;
    if (res.articles.isNotEmpty) {
      searchResultLength = res.articles.length;
    } else {
      searchResultLength = res.websites.length;
    }
    return SliverList(
      key: const Key('SearchResultListView'),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (res.articles.isNotEmpty) {
            return _rssItemWidget(res.articles[index]);
          } else {
            return _webSiteItem(res.websites[index]);
          }
        },
        childCount: searchResultLength,
      ),
    );
  }

  Widget _rssItemWidget(RssFeed feed) {
    //FIXME:検索結果表示Widgetはまだ動作確認用に仮組みに留めておく
    //feedlyを参考にカード形式が良いのか
    return ListTile(
      title: Text(feed.title),
    );
  }

  Widget _webSiteItem(WebSite site) {
    return ListTile(
      title: Text(site.name),
    );
  }
}
