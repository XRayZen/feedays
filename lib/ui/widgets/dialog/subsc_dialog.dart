// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionSiteDialog extends ConsumerWidget {
  final WebSite site;
  const SubscriptionSiteDialog({
    super.key,
    required this.site,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //https://zenn.dev/t_fukuyama/articles/5ee3f60311271b
    // を参考にダイアログを実装する
    // アラートダイアログでフォルダーを読み込んで動的に生成して選ぶか新たに追加することができる
    // シンプルダイアログは静的なコンテンツの表示に適している
    final list = ref.watch(readRssFolderProvider);
    return Column(
      children: [
        //フォルダー・カテゴリーを追加
        TextButton(
          onPressed: () {
            //さらに入力を促すダイアログを表示してカテゴリー名を入れてフォルダに追加する
          },
          child: const Text('Add Categories'),
        ),
        const Divider(),
        //フォルダーをリストで表示
        //BUG:表示されないエラーは https://qiita.com/NishiKeiqiita/items/15035fa16e3eb6bfd9aa で解決
        //ダイアログには静的なサイズが必要
        SizedBox(
          width: 400,
          height: 200,
          //スクロールバーを表示する
          //https://www.kamo-it.org/blog/flutter-scrollbar/
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
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
                      ref.watch(webUsecaseProvider).removeRssSite(site);
                    } else {
                      final editSite = site..category = list[index].name;
                      ref.watch(webUsecaseProvider).registerRssSite(editSite);
                    }
                    ref.watch(addedSiteProvider.notifier).state += 1;
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
        const Divider()
      ],
    );
  }
}

class AddedSite extends ConsumerWidget {
  final int folderIndex;
  final WebSite site;
  const AddedSite({
    super.key,
    required this.folderIndex,
    required this.site,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(readRssFolderProvider);
    //更新するために監視
    final count = ref.watch(addedSiteProvider);
    return Visibility(
      visible: anySiteOfRssFolders(list[folderIndex].name, site.siteUrl, ref),
      child: SizedBox(
        height: 50,
        width: 90,
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
      ),
    );
  }
}

Future showSubscriptionDialog(
  BuildContext context,
  WebSite site,
  WidgetRef ref,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // 背景色を半透明に変更。
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.64),
        title: const Text('Add Subscription Site'),
        //BUG:表示されないエラーは https://qiita.com/NishiKeiqiita/items/15035fa16e3eb6bfd9aa で解決
        content:
            SingleChildScrollView(child: SubscriptionSiteDialog(site: site)),
        //OK Cancel Button
        actions: [
          //OK
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('はい'),
          ),
          //Cancel
          TextButton(
            onPressed: () => {
              //  (5) ダイアログを閉じる
              Navigator.pop(context, false)
            },
            child: const Text('いいえ'),
          ),
        ],
      );
    },
  );
}
