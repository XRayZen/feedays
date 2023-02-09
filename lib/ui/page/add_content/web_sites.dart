import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
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
      children: [
        TextFormField(
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
  const _SearchTextField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __SearchTextFieldState();
}

class __SearchTextFieldState extends ConsumerState<_SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              titleSpacing: 5,
              title: SearchFieldWidget(),
              pinned: true,
              centerTitle: true,
              expandedHeight: 5,
            ),
            const SliverPadding(padding: EdgeInsets.all(10)),
            //ここから下は履歴か検索結果を切り替えて表示する
            //入力フォームの下に入力履歴がスライドしたらリムーブするリストタイルが縦で羅列している
            // 切り替えは関数化して個別Widgetはクラス化して描画を細かく分ける
            SliverToBoxAdapter(
              child: Wrap(
                children: const [Text('Recent Searches')],
              ),
            ),
            RecentSearchesListView()
          ];
        },
        body: const SizedBox(),
      ),
    );
  }
}
