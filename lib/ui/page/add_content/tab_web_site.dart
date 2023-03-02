import 'package:feedays/ui/page/search_page.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabWebSite extends ConsumerWidget {
  const TabWebSite({super.key});

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
            //FIXME:feedlyでは遷移ではなくタブバービューを変えている
            ref.watch(barViewTypeProvider.notifier).state =
                TabBarViewType.searchView;
          },
          onTap: () {
            ref.watch(searchResultViewMode.notifier).state =
                SearchResultViewMode.none;
            ref.watch(searchResultProvider.notifier).clear();
            ref.watch(barViewTypeProvider.notifier).state =
                TabBarViewType.searchView;
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
