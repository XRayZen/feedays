// ignore_for_file: public_member_api_docs, sort_constructors_first, inference_failure_on_instance_creation
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/main.dart';
import 'package:feedays/ui/page/detail/html_view.dart';
import 'package:feedays/ui/widgets/search_view/custom_text_field.dart';
import 'package:feedays/ui/widgets/search_view/search_view.dart';
import 'package:feedays/ui/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliver_tools/sliver_tools.dart';

class FeedDetailPage extends ConsumerWidget {
  final List<RssFeedItem> articles;
  final int index;
  const FeedDetailPage({
    super.key,
    required this.index,
    required this.articles,
  });

  //スワイプするととなりのフィード詳細に遷移

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = articles[index];
    return Scaffold(
      //TODO:スクロールするためにスクロールビューを入れる
      //左右のスワイプを検知する
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            //左スワイプで次
            nextPageNavigate(context, backOrNext: false);
          } else if (details.primaryVelocity! > 0) {
            // 右スワイプで前
            nextPageNavigate(context);
          }
        },
        onVerticalDragEnd: (details) {
          //TODO:上下にスワイプしたらアニメーションしてポップ
          if (details.primaryVelocity! < 0) {
            //左スワイプで次
            showSnack(context, 500, 'up');
          } else if (details.primaryVelocity! > 0) {
            // 右スワイプで前
            showSnack(context, 500, 'down');
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                titleSpacing: 5,
                pinned: true,
                //スワイプで前後にページ遷移するから通常だと前の記事に戻るからResultに戻りたい
                leading: BackButton(
                  onPressed: () {
                    //リザルトにバックした時に候補を非表示にしておく
                    ref.watch(searchResultViewMode.notifier).state =
                        SearchResultViewMode.result;
                    ref.watch(visibleRecentViewProvider.notifier).state = false;
                    ref.watch(isSearchTxtAutoFocus.notifier).state =
                        false; //オートフォーカスをオフにしておく
                    //リザルトビューでバックボタンしたらそれも空にしておく
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                ),
                //アクションに
                actions: [
                  // テーマやサイズを設定できる小ウインドウを表示させるAaアイコンボタン
                  IconButton(
                    tooltip: 'Set theme and size',
                    onPressed: () {
                      //テーマやサイズを設定できる小ウインドウを表示
                    },
                    icon: const Icon(Icons.format_size),
                  ),
                  //ReadLaterフラグを立てるアイコン・ボタン
                  // お気に入り登録するアイコン・ボタン
                  //プラットフォームごとに動作するシェアボタン
                  //外部サービスと連携して記事を送信できる3ポイントアイコン・ボタン
                ],
              )
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverStack(
                children: [
                  //記事オブジェクト
                  //フィード詳細は中央に配置
                  SliverToBoxAdapter(
                    child: FeedDetailBody(article: article),
                  ),
                  //画面全体として縦長に3つのGestureDetectorを置き画面左右のタップ操作を検知
                  // leftRightTapDetect(context)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row leftRightTapDetect(BuildContext context) {
    return Row(
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

  void nextPageNavigate(BuildContext context, {bool backOrNext = true}) {
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

class FeedDetailBody extends StatelessWidget {
  const FeedDetailBody({
    super.key,
    required this.article,
  });

  final RssFeedItem article;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Column(
          children: [
            //長かったら折り返す
            //一番上に太字でタイトル
            Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            //その下に小さくサイト名/by {Domain}/記事日時
            Text(
              //FIXME:バグが出る可能性があるからドメイン名抽出は関数化して対策する
              '${article.site}/by ${article.link.split('//').elementAt(1).split('/').elementAt(0)}/${article.lastModified}',
            ),
            //ディスクリプション
            //Htmlを使おうとすればビルドできなくなる
            //NOTE:チャンネルをステープルにしてようやく出来た
            HtmlWidget(data: article.description),
            //横に配置でシェアボタンとビューWebサイトボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: ElevatedButton(
                    onPressed: () {
                      //Shareダイアログ表示
                    },
                    style: ElevatedButton.styleFrom(
                      animationDuration: const Duration(seconds: 3),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: const Text('Share'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: ElevatedButton(
                    onPressed: () {
                      //内部ブラウザでサイトを開く
                    },
                    style: ElevatedButton.styleFrom(
                      animationDuration: const Duration(seconds: 1),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: const Text('View WEBSITE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
