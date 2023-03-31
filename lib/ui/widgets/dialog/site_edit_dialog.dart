// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_function_invocation, lines_longer_than_80_chars
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/widgets/dialog/subsc_dialog.dart';
import 'package:feedays/ui/widgets/switch_fav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showSiteEditDialog(
  String folderName,
  WebSite site,
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: SiteEditDialogWidget(
            folderName: folderName,
            site: site,
          ),
        ),
      );
    },
  );
}

class SiteEditDialogWidget extends ConsumerStatefulWidget {
  final WebSite site;
  final String folderName;
  const SiteEditDialogWidget({
    super.key,
    required this.folderName,
    required this.site,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SiteEditDialogWidgetState();
}

class _SiteEditDialogWidgetState extends ConsumerState<SiteEditDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.site.name,
          style: const TextStyle(fontSize: 20),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        IconButton(
          tooltip: 'Rename',
          onPressed: () {
            //名前を変更するダイアログを表示する
            showRenameDialog(context, ref);
          },
          icon: Row(
            children: const [
              Icon(Icons.edit),
              Padding(padding: EdgeInsets.all(5)),
              Text('Rename'),
            ],
          ),
        ),
        //お気に入り
        SwitchFavorite(site: widget.site),
        //カテゴリー選択
        IconButton(
          tooltip: 'Category',
          onPressed: () {
            //カテゴリーを変更するダイアログを表示する
            showSubscriptionDialog(
              context,
              'Edit Site Category',
              widget.site,
              ref,
            );
          },
          icon: Row(
            children: const [
              Icon(Icons.category),
              Padding(padding: EdgeInsets.all(5)),
              Text('Category'),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: () async {
            //削除するダイアログを表示する
            await showDeleteDialog(context, ref);
            //もしサイトが削除されていたらダイアログを閉じる
            if (ref
                    .read(useCaseProvider)
                    .userCfg
                    .rssFeedSites
                    .anySiteOfURL(widget.site.siteUrl) ==
                false) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          },
          icon: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red),
              Padding(padding: EdgeInsets.all(5)),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  //サイトの名前を変更するダイアログを表示する
  Future<void> showRenameDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) {
        var txt = widget.site.name;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Rename'),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: TextEditingController(text: widget.site.name),
                  decoration: const InputDecoration(
                    labelText: 'New name',
                  ),
                  onChanged: (value) => txt = value,
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        //サイトの名前を変更する
                        setState(() {
                          ref
                              .watch(rssUsecaseProvider)
                              .renameSite(widget.site, txt);
                          ref.watch(onChangedProvider.notifier).state += 1;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //サイトを削除するか確認するダイアログを表示する
  Future<void> showDeleteDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Delete'),
                const Padding(padding: EdgeInsets.all(10)),
                const Text('Are you sure you want to delete this site?'),
                const Padding(padding: EdgeInsets.all(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        //サイトを削除する
                        setState(() {
                          ref
                              .watch(rssUsecaseProvider)
                              .removeRssSite(widget.folderName, widget.site);
                          ref.watch(onChangedProvider.notifier).state += 1;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
