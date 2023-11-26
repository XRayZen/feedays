
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionSiteDialog extends ConsumerWidget {
  const SubscriptionSiteDialog({
    super.key,
    required this.site,
  });
  final WebSite site;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //https://zenn.dev/t_fukuyama/articles/5ee3f60311271b
    // を参考にダイアログを実装する
    // アラートダイアログでフォルダーを読み込んで動的に生成して選ぶか新たに追加することができる
    // シンプルダイアログは静的なコンテンツの表示に適している
    final list = ref.watch(readRssFolderProvider);
    // ignore: unused_local_variable
    final count = ref.watch(onChangedProvider);
    final scrollCtrl = ScrollController();
    return Column(
      children: [
        //フォルダー・カテゴリーを追加
        TextButton(
          onPressed: () {
            //さらに入力を促すダイアログを表示してカテゴリー名を入れてフォルダに追加する
            inputCategoryNameDialog(context, ref);
          },
          child: const Text('Add Categories'),
        ),
        const Divider(thickness: 10),
        //フォルダーをリストで表示
        //表示されないエラーは https://qiita.com/NishiKeiqiita/items/15035fa16e3eb6bfd9aa で解決
        //ダイアログにはサイズ指定が必要
        SizedBox(
          width: 400,
          height: 200,
          //スクロールバーを表示する
          //https://www.kamo-it.org/blog/flutter-scrollbar/
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollCtrl,
            child: ListView.separated(
              controller: scrollCtrl,
              shrinkWrap: true,
              itemCount: list.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    //削除するか尋ねるダイアログ
                    deleteCategoryDialog(context, list, index, ref);
                  },
                  onTap: () {
                    siteAddOrDelete(list, index, ref);
                  },
                  title: Text(list[index].name),
                  //そのフォルダにサイトが存在していたら表示する
                  trailing: AddedSite(
                    folderIndex: index,
                    site: site,
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(
          thickness: 10,
        )
      ],
    );
  }

  void deleteCategoryDialog(
    BuildContext context,
    List<RssFeedFolder> list,
    int index,
    WidgetRef ref,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final deleteName = list[index].name;
        return AlertDialog(
          title: Text('Category:( $deleteName ) to be delete?'),
          actions: [
            TextButton(
              onPressed: () async {
                //指定したフォルダー・カテゴリーを削除する
                await ref
                    .watch(rssUsecaseProvider)
                    .removeSiteFolder(deleteName);
                ref.watch(onChangedProvider.notifier).state += 1;
                if (context.mounted){
                  // ダイアログを閉じる
                  Navigator.pop(context, true);
                }
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void inputCategoryNameDialog(BuildContext context, WidgetRef ref) {
    //さらに入力を促すダイアログを表示してカテゴリー名を入れてフォルダに追加する
    var text = '';
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Input Category Name'),
          content: TextField(
            onChanged: (value) {
              //プロバイダーに保存
              text = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                //フォルダー・カテゴリー名でカテゴリーを追加
                if (text != '') {
                  ref.watch(rssUsecaseProvider).rssFeedData.addFolder(text);
                  //ステートレスだとSetStateが使えないからプロバイダーを使って更新
                  ref.watch(onChangedProvider.notifier).state += 1;
                }
                Navigator.pop(context, true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void siteAddOrDelete(List<RssFeedFolder> list, int index, WidgetRef ref) {
    //タップしたら登録・削除処理
    //フォルダにサイトが無かったら登録してあったら削除する
    //サイト登録処理
    //feedlyならSelect Folderが横からスライドしてきて入れるフォルダを選択できる
    //それ以外をタップしたらスライドしてもとに戻る
    if (anySiteOfRssFolders(
      list[index].name,
      site.siteUrl,
      ref,
    )) {
      ref.watch(rssUsecaseProvider).removeRssSite(list[index].name, site);
    } else {
      //ここでサイトを変更すると大元のサイトも変更されてしまうからコピーしてから変更する
      final newEditSite = WebSite(
        key: site.key,
        name: site.name,
        siteUrl: site.siteUrl,
        siteName: site.siteName,
        iconLink: site.iconLink,
        tags: site.tags,
        feeds: site.feeds,
        description: site.description,
        lastModified: site.lastModified,
      )
        ..index = site.index
        ..category = list[index].name
        ..rssUrl = site.rssUrl
        ..newCount = site.newCount
        ..readLateCount = site.readLateCount
        ..fav = site.fav
        ..isCloudFeed = site.isCloudFeed;
      ref.watch(rssUsecaseProvider).registerRssSite([newEditSite]);
    }
    ref.watch(onChangedProvider.notifier).state += 1;
  }
}

class AddedSite extends ConsumerWidget {
  const AddedSite({
    super.key,
    required this.folderIndex,
    required this.site,
  });
  final int folderIndex;
  final WebSite site;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(readRssFolderProvider);
    //更新するために監視
    // ignore: unused_local_variable
    final count = ref.watch(onChangedProvider);
    return Visibility(
      visible: anySiteOfRssFolders(list[folderIndex].name, site.siteUrl, ref),
      //ダイアログにはサイズ指定が必要
      child: const SizedBox(
        height: 50,
        width: 90,
        child: Row(
          children: [
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
      ),
    );
  }
}

Future<void> showSubscriptionDialog(
  BuildContext context,
  String title,
  WebSite site,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        // 背景色を半透明に変更。
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.64),
        title: Text(title),
        //NOTE:表示されないエラーは https://qiita.com/NishiKeiqiita/items/15035fa16e3eb6bfd9aa で解決
        content:
            SingleChildScrollView(child: SubscriptionSiteDialog(site: site)),
        actions: [
          //OK
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              ref.watch(onChangedProvider.notifier).state += 1;
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
