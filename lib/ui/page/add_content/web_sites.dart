import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebSites extends ConsumerWidget {
  const WebSites({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //NOTE:feedlyではWebSitesにのみピンされたテキストフィールドがあるが、
    //細かな再現には時間がかかりすぎるからそこまで求めない
    //NOTE:若干feedlyとUI動作は異なるが速度優先で仕上げる
    return Column(
      children: [
        TextField(
          //PLAN:入力履歴はローカル・クラウド両方に保存しておく
          onChanged: (value) {},
        ),
        //PLAN:カテゴリごとにおすすめが配置されている
      ],
    );
  }
}
