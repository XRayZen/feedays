import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedays/domain/entities/web_sites.dart';
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
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: 150,
                height: 100,
                imageUrl: articles[index].image.link,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
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
