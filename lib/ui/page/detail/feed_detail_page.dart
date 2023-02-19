// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/main.dart';
import 'package:feedays/ui/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedDetailPage extends ConsumerWidget {
  final List<RssFeed> articles;
  final int index;
  const FeedDetailPage({
    super.key,
    required this.index,
    required this.articles,
  });

  //スワイプするととなりのフィード詳細に遷移

  //フィード詳細は中央に配置
  //全体は縦に配置して
  //一番上に太字でタイトル
  //その下に小さくサイト名/by {Domain}/記事日時
  //横に配置でイメージとディスクリプション
  //横に配置でシェアボタンとビューWebサイトボタン
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = articles[index];
    return Scaffold(
      appBar: AppBar(
          //バーはリーディングはシンプルにバックボタン（自動で実装か）
          //多分アクションにテーマやサイズを設定できる小ウインドウを表示させるAaアイコンボタン
          //ReadLaterフラグを立てるアイコン・ボタン
          //お気に入り登録するアイコン・ボタン
          //プラットフォームごとに動作するシェアボタン
          //外部サービスと連携して記事を送信できる3ポイントアイコン・ボタン
          ),
      body: Stack(
        children: [
          //記事オブジェクト
          Center(
            child: Column(
              children: [
                //一番上に太字でタイトル
                Text(article.title),
                //その下に小さくサイト名/by {Domain}/記事日時
                
              ],
            ),
          ),
          //左右のスワイプを検知する
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                showSnack(
                  context,
                  500,
                  '左 swipe',
                );
              } else if (details.primaryVelocity! > 0) {
                showSnack(
                  context,
                  500,
                  '右 swipe',
                );
              }
            },
          ),
          //画面全体として縦長に3つのGestureDetectorを置き画面左右のタップ操作を検知
          Row(
            children: [
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    //左のタップ
                    showSnack(
                      context,
                      500,
                      '左のタップ',
                    );
                  },
                ),
              ),
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    //中央のタップ
                    scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('中央にtap'),
                      ),
                    );
                  },
                ),
              ),
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    //右のタップ
                    scaffoldMessengerKey.currentState!.showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('右にtap'),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //画面配置に成功した例
  GestureDetector rowStan(BuildContext context) {
    return GestureDetector(
      //BUG:スワイプを検知出来ていない
      onHorizontalDragUpdate: detectSwipe,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                // color: Colors.yellow,
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Tap right edge'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                child: const Center(child: Text('Tap center')),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // color: Colors.yellow,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Center(child: Text('Tap left edge')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///左右どちらにスワイプしたか検知
  void detectSwipe(DragUpdateDetails details) {
    const sensitivity = 8;
    if (details.delta.dx > sensitivity) {
      //右にスワイプ
      //前のインデックスのフィードに遷移
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text('右にswipe')));
    } else if (details.delta.dx < -sensitivity) {
      //左にスワイプ
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text('左にswipe')));
    }
  }

  void pageNavigate(BuildContext context) {
    if (articles.length < index + 1) {
      // Right edge tap
      Navigator.of(context).push(
        PageRouteBuilder(
          //アニメーション
          pageBuilder: (context, animation, secondaryAnimation) =>
              FeedDetailPage(index: index + 1, articles: articles),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }
}
