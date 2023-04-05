import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/page/detail/feed_detail_page.dart';
import 'package:feedays/ui/widgets/imageView/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RssFeedItemUI extends ConsumerWidget {
  const RssFeedItemUI({super.key, required this.articles, required this.index});
  final List<FeedItem> articles;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //uiConfigを取得
    return GestureDetector(
      onTap: () {
        //タップしたらフィード詳細ページに遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FeedDetailPageView(index: index, articles: articles),
          ),
        );
      },
      child: Card(
        child: Row(
          children: [
            //先頭横にイメージを四角で表示
            SizedBox.square(
              child: CachedNetworkImageView(
                link: articles[index].image.link,
                fit: BoxFit.fill,
                width: 150,
                height: 100,
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //タイトルは太字
                  Text(
                    articles[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(3)),
                  Text(articles[index].lastModified.toLocal().toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
