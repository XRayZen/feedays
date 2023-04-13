// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/detail/site_datail/site_feed_list.dart';
import 'package:feedays/ui/provider/rss_feeds_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/dialog/subsc_dialog.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    final count = ref.watch(onChangedProvider);
    return _buildBody(ref);
  }

  Scaffold _buildBody(WidgetRef ref) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              pinned: true,
              expandedHeight: 100,
              //フレキシブル無しでもいいが、若干視認性が悪くなるのでフレキシブルにしておく
              // title: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: appBarLayout(context, ref),
              // ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                title: SafeArea(
                  minimum: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: appBarLayout(context, ref),
                  ),
                ),
              ),
            )
          ];
        },
        body: SiteRssFeedList(site: site!),
      ),
    );
  }

  ///解像度に応じてレイアウトを変える
  List<Widget> appBarLayout(BuildContext context, WidgetRef ref) {
    if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      //モバイルの場合
      return [
        switchFavoriteButton(
          site,
          const Icon(Icons.favorite),
          const Icon(Icons.favorite_border),
          ref,
        ),
        Flexible(
          child: Text(
            site!.name,
            style: const TextStyle(
              //モバイルだとこのサイズでないと文字がスマホのトップバーに入ってしまい視認性が悪くなる
              //SafeAreaを使っても解決しなかったので現時点ではこのサイズで固定する
              fontSize: 12,
            ),
          ),
        ),
        Flexible(
          child: IconButton(
            key: const Key('RefreshButton'),
            onPressed: () {
              //RSSを更新する
              ref.watch(reTryRssFeedProvider.notifier).retry(context, site!);
            },
            icon: const Icon(Icons.refresh),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: switchFollowButton(context, ref, site),
        ),
      ];
    } else {
      //タブレットの場合
      return [
        // const Padding(padding: EdgeInsets.all(78)),
        Expanded(child: Container()),
        Expanded(child: Container()),
        switchFavoriteButton(
          site,
          const Icon(Icons.favorite),
          const Icon(Icons.favorite_border),
          ref,
        ),
        Text(
          site!.name,
          style: TextStyle(
            fontSize: getResponsiveValue(context),
          ),
        ),
        // const Padding(padding: EdgeInsets.all(10)),
        IconButton(
          key: const Key('RefreshButton'),
          onPressed: () {
            //RSSを更新する
            ref.watch(reTryRssFeedProvider.notifier).retry(context, site!);
          },
          icon: const Icon(Icons.refresh),
        ),
        Expanded(child: Container()),
        Align(
          alignment: Alignment.centerLeft,
          child: switchFollowButton(context, ref, site),
        ),
        Expanded(child: Container()),
        // const Padding(padding: EdgeInsets.all(7)),
      ];
    }
  }

  //未購読ならフォローボタンを表示する
  Widget switchFollowButton(
    BuildContext context,
    WidgetRef ref,
    WebSite? site,
  ) {
    if (site != null) {
      return Visibility(
        visible: !ref
            .watch(rssUsecaseProvider)
            .rssFeedData
            .anySiteOfURL(site.siteUrl),
        child: TextButton(
          onPressed: () async {
            //購読処理
            //feedlyではスライドしてフォルダを選択するがここはダイアログで選択する
            await showSubscriptionDialog(
              context,
              'Add Subscription',
              site,
              ref,
            );
            //購読処理をしたら更新する必要がある
            ref.watch(onChangedProvider.notifier).state += 1;
          },
          child: const Text(
            'FOLLOW',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
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

class SiteBarTitle extends ConsumerWidget {
  WebSite? site;
  SiteBarTitle({
    super.key,
    required this.site,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // const Padding(padding: EdgeInsets.only(right: 110)),
        switchFavoriteButton(
          site,
          const Icon(Icons.favorite),
          const Icon(Icons.favorite_border),
          ref,
        ),
        // const Padding(padding: EdgeInsets.all(10)),
        Text(
          site!.name,
          style: TextStyle(
            fontSize: getResponsiveValue(context),
          ),
        ),
        // const Padding(padding: EdgeInsets.all(10)),
        IconButton(
          key: const Key('RefreshButton'),
          onPressed: () {
            //RSSを更新する
            ref.watch(reTryRssFeedProvider.notifier).retry(context, site!);
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

Widget switchFavoriteButton(
    WebSite? site, Widget onFavIcon, Widget offFavIcon, WidgetRef ref) {
  if (site != null) {
    if (ref
        .watch(favSitesProvider)
        .any((element) => element.siteUrl == site.siteUrl)) {
      return IconButton(
        tooltip: 'Tap to remove from favorites.',
        onPressed: () {
          ref
              .watch(favSitesProvider)
              .removeWhere((element) => element.siteUrl == site.siteUrl);
          ref.watch(onChangedProvider.notifier).state += 1;
        },
        color: Colors.pink,
        icon: onFavIcon,
      );
    } else {
      return IconButton(
        tooltip: 'Add Favorite',
        onPressed: () async {
          //お気に入り登録
          if (site != null) {
            ref.watch(favSitesProvider).add(site);
            ref.watch(onChangedProvider.notifier).state += 1;
          }
        },
        icon: offFavIcon,
      );
    }
  } else {
    return Container();
  }
}
