// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_instance_creation
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/main.dart';
import 'package:feedays/ui/widgets/search_view/custom_text_field.dart';
import 'package:feedays/ui/widgets/search_view/search_view.dart';
import 'package:feedays/ui/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

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
        //だがスワイプで前後にページ遷移するからいちいちとなりの記事に遷移せずResultに戻りたい
        //だから手動でバックボタンを実装する
        leading: BackButton(
          onPressed: () {
            //リザルトにバックした時に候補を非表示にしておく
            ref.watch(searchResultViewModeProvider.notifier).state =
                SearchResultViewMode.result;
            ref.watch(visibleRecentViewProvider.notifier).state = false;
            ref.watch(isSearchTxtAutoFocus.notifier).state =
                false; //オートフォーカスをオフにしておく
            //BUG:リザルトのテキストフィールドが空になっている→テキストフィールドがステートレスだから
            //TODO:テキストフィールドのテキストを随時ステートプロバイダーに保存して
            //描画する時に入れておく
            //リザルトビューでバックボタンしたらそれも空にしておく
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        //多分アクションにテーマやサイズを設定できる小ウインドウを表示させるAaアイコンボタン
        //ReadLaterフラグを立てるアイコン・ボタン
        //お気に入り登録するアイコン・ボタン
        //プラットフォームごとに動作するシェアボタン
        //外部サービスと連携して記事を送信できる3ポイントアイコン・ボタン
        actions: [
          IconButton(
            tooltip: 'Set theme and size',
            onPressed: () {
              //テーマやサイズを設定できる小ウインドウを表示
            },
            icon: const Icon(Icons.format_size),
          )
        ],
      ),
      body: Stack(
        children: [
          //記事オブジェクト
          Center(
            child: Column(
              children: [
                //長かったら折り返す
                //一番上に太字でタイトル
                Text(article.title),
                //その下に小さくサイト名/by {Domain}/記事日時
                Text(
                  '${article.site}/by ${article.link.split('//').elementAt(1).split('/').elementAt(0)}/${article.lastModified}',
                ),
              ],
            ),
          ),
          //左右のスワイプを検知する
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                //左スワイプで次
                showSnack(
                  context,
                  500,
                  '右から左 swipe',
                );
                nextPageNavigate(context, false);
              } else if (details.primaryVelocity! > 0) {
                // 右スワイプで前
                showSnack(
                  context,
                  500,
                  '左から右 swipe',
                );
                nextPageNavigate(context, true);
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

  Widget slideTransition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.ease;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  //画面配置に成功した例
  GestureDetector rowStan(BuildContext context) {
    return GestureDetector(
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

  void nextPageNavigate(BuildContext context, bool backOrNext) {
    if (backOrNext) {
      //前の記事に遷移
      //マイナスになったら遷移しない
      if (0 <= index - 1) {
        Navigator.of(context).push(
          PageTransition(
            child: FeedDetailPage(index: index - 1, articles: articles),
            type: PageTransitionType.leftToRightJoined,
            childCurrent: this,
          ),
        );
      }
    } else {
      if (articles.length > index + 1) {
        // 次の記事に遷移
        Navigator.of(context).push(
          PageTransition(
            child: FeedDetailPage(index: index + 1, articles: articles),
            type: PageTransitionType.rightToLeft,
            childCurrent: this,
          ),
        );
      }
    }
  }
}
