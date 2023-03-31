
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

///シェア機能を呼び出す
///
///iPadの場合は呼び出すWidgetをビルダーでラップする必要がある
Future<void> callShare(BuildContext context, String url, String subject) async {
  final box = context.findRenderObject() as RenderBox?;
  //端末固有のシェア機能を呼ぶ
  await Share.share(
    url,
    subject: subject,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}
