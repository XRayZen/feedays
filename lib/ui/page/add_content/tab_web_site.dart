import 'package:feedays/ui/page/search_view_page.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/exploreWeb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TabWebSite extends ConsumerWidget {
  const TabWebSite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //NOTE:feedlyではWebSitesにのみピンされたテキストフィールドがあるが、
    //細かな再現には時間がかかりすぎるからそこまで求めない
    //NOTE:若干feedlyとUI動作は異なるが速度優先で仕上げる
    final con = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        key: const Key('WebsitesColumn'),
        children: [
          TextFormField(
            key: const Key('SearchTextFieldTap'),
            controller: con,
            onChanged: (value) {
              con.clear();
              //feedlyでは遷移ではなくタブバービューを変えている
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
          const Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Recommended for you',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          ResponsiveRowColumn(
            layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowMainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveRowColumnItem(rowFlex: 1, child: Container()),
              ResponsiveRowColumnItem(rowFlex: 1, child: ExploreWeb(con: con)),
              ResponsiveRowColumnItem(rowFlex: 1, child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
