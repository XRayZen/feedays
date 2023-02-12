import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/recent_searches.dart';
import 'package:feedays/ui/widgets/search_field_widget.dart';
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
            //TODO:ページをバックしたら検索結果をクリアする
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              titleSpacing: 5,
              title: const SearchFieldWidget(key: Key('SearchFieldWidget')),
              pinned: true,
              centerTitle: true,
              expandedHeight: 5,
              //FIXME:バックしたら検索結果をクリアするため手動でバックボタンを実装する
            ),
            const SliverPadding(padding: EdgeInsets.all(10)),
            //ここから下は履歴か検索結果を切り替えて表示する
            //入力フォームの下に入力履歴がスライドしたらリムーブするリストタイルが縦で羅列している
            // 切り替えは関数化して個別Widgetはクラス化して描画を細かく分ける
            //BUG:非表示が確認出来ないから別クラスにするかプロバイダー監視を上に置く
            SliverVisibility(
              visible: isVisible,
              sliver: SliverToBoxAdapter(
                key: const Key('RecentSearchesText'),
                child: Wrap(
                  children: const [Text('Recent Searches')],
                ),
              ),
            ),
            // RecentSearchesListView(),
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
    final mode = ref.watch(recentOrResultProvider);
    return _recentOrResultWidget(mode, ref);
  }

  Widget _recentOrResultWidget(RecentOrResult result, WidgetRef ref) {
    switch (result) {
      case RecentOrResult.recent:
        return RecentSearchesListView();
      case RecentOrResult.result:
        //resultなら消しておく
        ref.watch(visibleRecentTextProvider.notifier).state = false;
        return SearchResultView();
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

  Widget howResult(SearchResult res) {
    //TODO:非同期でリクエストするから出来るのならFutureProviderで監視したい
    switch (res.resultType) {
      case SearchResultType.found:
        return _buildSearchResultList(res);
      case SearchResultType.none:
        //初期状態
        return const SliverToBoxAdapter(child: CircularProgressIndicator());
      case SearchResultType.error:
        //PLAN:exceptionも出力する予定
        return SliverToBoxAdapter(
          child: ListTile(title: Text(res.exception.toString())),
        );
    }
  }

  Widget _buildSearchResultList(SearchResult res) {
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
