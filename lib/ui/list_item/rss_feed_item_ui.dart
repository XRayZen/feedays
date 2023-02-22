import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/ui/page/detail/feed_detail_page.dart';
import 'package:flutter/material.dart';

class RssFeedItemUI extends StatelessWidget {
  const RssFeedItemUI({super.key, required this.articles, required this.index});
  final List<RssFeedItem> articles;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //タップしたらフィード詳細ページに遷移
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FeedDetailPage(index: index, articles: articles),
          ),
        );
      },
      child: Card(
        child: Row(
          children: [
            //先頭横にイメージを四角で表示
            SizedBox.square(
              child: Image.network(
                width: 70,
                height: 65,
                articles[index].image.link,
              ),
              //  Image.memory(
              //   width: 70,
              //   height: 65,
              //   articles[index].image.image.buffer.asUint8List(),
              // ),
            ),
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
                  //FIXME:feedlyでは現時点の経過時間を表示している
                  Text(articles[index].lastModified.toLocal().toString()),
                  //最後にディスクリプション
                  // HtmlWidget(articles[index].description),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
