import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/widgets/recent_searches.dart';
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
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              titleSpacing: 5,
              title: TextFieldWidget(controller: _controller),
              pinned: true,
              centerTitle: true,
              expandedHeight: 5,
            ),
          ];
        },
        body:
            //ここから下は履歴か検索結果を切り替えて表示する
            //入力フォームの下に入力履歴がスライドしたらリムーブするリストタイルが縦で羅列している
            // 切り替えは関数化して個別Widgetはクラス化して描画を細かく分ける
            Wrap(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text('Recent Searches'),
            // ignore: prefer_const_constructors
            RecentSearchesListView()
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends ConsumerWidget {
  const TextFieldWidget({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: _controller,
      //PLAN:入力履歴はローカル・クラウド両方に保存しておく
      autofocus: true,
      onFieldSubmitted: (value) {
        //プロバイダーにテキストを送信して処理をする
        ref.watch(webUsecaseProvider).editRecentSearches(value);
      },
      onChanged: (value) {
        //NOTE:入力されるたびに呼び出されたら都度検索して候補を提示する
        //ユーザーが入力し終えたら検索処理をするという実装
        
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(Icons.search),
        //今はURLしか機能しない
        //その他はクラウド機能で実現
        hintText: 'Type a name, topic, or paste a URL',
      ),
    );
  }
}
