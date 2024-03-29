// import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/detail/site_detail_page.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/dialog/subsc_dialog.dart';
import 'package:feedays/ui/widgets/imageView/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteListItem extends ConsumerWidget {
  const SiteListItem({required this.site, super.key});
  final WebSite site;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        ref.watch(selectWebSiteProvider.notifier).state = site;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SiteDetailPage(
              site: site,
            ),
          ),
        );
      },
      child: Center(
        child: SizedBox(
          width: 800,
          child: Card(
            //ListTileには頼らず手動で実装する
            //全体的に縦に配置
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //アイコンとタイトルと追加アイコン・ボタンを配置
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //アイコンにサイトメタのイメージを配置
                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox.square(
                        child: CachedNetworkImageView(
                          link: site.iconLink,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //ここを縦で配置してタイトル/サブタイトル/ディスクリプション/フィード最新抜粋
                    //タイトル太字で大きく
                    Flexible(
                      child: Column(
                        // 余白を追加
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            site.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          //ディスクリプション
                          Text(site.description),
                          //PLAN:クラウド必須だがフォロワー数と週間記事数を表示しているが今は実装しない
                        ],
                      ),
                    ),
                    //追加アイコン・ボタン
                    IconButton(
                      onPressed: () {
                        showSubscriptionDialog(
                          context,
                          'Add Subscription',
                          site,
                          ref,
                        );
                      },
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
