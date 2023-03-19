// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/detail/site_datail/site_feed_list.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/dialog/subsc_dialog.dart';
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
  //siteがnullならドロワーメニューから
  //nullじゃないのならサイト検索から
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
    //Widget更新用
    // ignore: unused_local_variable
    final count = ref.watch(addedSiteProvider);
    return _buildBody(ref);
  }

  Scaffold _buildBody(WidgetRef ref) {
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
              flexibleSpace: FlexibleSpaceBar(
                title: SafeArea(
                  child: Row(
                    //スペーサーを指定して隙間を開けておく
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Container()),
                            switchFavoriteButton(ref),
                            const Padding(padding: EdgeInsets.all(5)),
                            Text(
                              site!.name,
                              style: TextStyle(
                                fontSize: getResponsiveValue(context),
                              ),
                            ),
                            Expanded(child: Container()),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: switchFollowButton(context, ref, site),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget switchFavoriteButton(WidgetRef ref) {
    if (site != null) {
      if (ref
          .watch(favSitesProvider)
          .any((element) => element.siteUrl == site!.siteUrl)) {
        return IconButton(
          tooltip: 'Tap to remove from favorites.',
          onPressed: () {
            ref
                .watch(favSitesProvider)
                .removeWhere((element) => element.siteUrl == site!.siteUrl);
            ref.watch(addedSiteProvider.notifier).state += 1;
          },
          color: Colors.pink,
          icon: const Icon(Icons.favorite),
        );
      } else {
        return IconButton(
          tooltip: 'Add Favorite',
          onPressed: () async {
            //お気に入り登録
            if (site != null) {
              ref.watch(favSitesProvider).add(site!);
              ref.watch(addedSiteProvider.notifier).state += 1;
            }
          },
          icon: const Icon(Icons.favorite_border),
        );
      }
    } else {
      return Container();
    }
  }

  Widget switchFollowButton(
    BuildContext context,
    WidgetRef ref,
    WebSite? site,
  ) {
    if (site != null) {
      if (ref
          .watch(webUsecaseProvider)
          .userCfg
          .rssFeedSites
          .anySiteOfURL(site.siteUrl)) {
        //既にあるのならチェックマークのアイコンで登録済みだと示す
        return GestureDetector(
          onTap: () async {
            await showSubscriptionDialog(context, site, ref);
            ref.watch(addedSiteProvider.notifier).state += 1;
          },
          child: Row(
            children: const [
              Text(
                'ADDED',
                style: TextStyle(
                  color: Colors.lightGreen,
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              Icon(color: Colors.lightGreen, Icons.check_circle),
            ],
          ),
        );
      } else {
        //未購読ならフォローボタンを表示
        return Flexible(
          child: TextButton(
            onPressed: () async {
              //購読処理
              //feedlyではスライドしてフォルダを選択するがここはダイアログで選択する
              await showSubscriptionDialog(context, site, ref);
              //購読処理をしたら更新する必要がある
              ref.watch(addedSiteProvider.notifier).state += 1;
            },
            child: const Text(
              'FOLLOW',
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      }
    }
    return Row(
      children: const [
        Text('ADDED'),
        Padding(padding: EdgeInsets.all(2)),
        Icon(Icons.check_circle),
      ],
    );
  }
}
