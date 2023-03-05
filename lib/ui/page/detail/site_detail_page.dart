// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/detail/site_datail/site_feed_list.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailPage extends ConsumerWidget {
  WebSite? site;
  SiteDetailPage({
    super.key,
    this.site,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (site != null) {
      //サイト検索から
      return SiteDetailWidget(site: site);
    } else {
      //ドロワーメニューから
      return SiteDetailWidget();
    }
  }
}

class SiteDetailWidget extends ConsumerWidget {
  WebSite? site;
  SiteDetailWidget({
    super.key,
    this.site,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ここで画面が切り替わらない原因になっていたため修正した
    final selectSite = ref.watch(selectWebSiteProvider);
    if (site?.siteUrl != selectSite.siteUrl) {
      site = selectSite;
    }
    return _buildBody();
  }

  Scaffold _buildBody() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          //バックボタン(leading)はハートボタンでお気に入り登録
          //バーはフレキシブルで最後にFOLLOWテキストボタン
          //スクロールした後のタイトルはサイトの名前
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              pinned: true,
              expandedHeight: 100,
              actions: [
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      //購読処理
                      //feedlyではスライドしてフォルダを選択するがここはダイアログで選択する
                    },
                    child: const Text(
                      'FOLLOW',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  //スペーサーを指定して隙間を開けておく
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Add Favorite',
                            onPressed: () async {
                              //お気に入り登録
                            },
                            icon: const Icon(Icons.favorite),
                          ),
                          Text(
                            site!.name,
                            style: TextStyle(
                              fontSize: getResponsiveValue(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            )
          ];
        },
        body: SiteDetailFeedList(site: site!),
      ),
    );
  }
}
