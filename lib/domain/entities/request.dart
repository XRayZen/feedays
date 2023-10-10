// ignore_for_file: public_member_api_docs, sort_constructors_first

class FetchFeedRequest {
  final String siteUrl;
  // 更新間隔（分）
  final int intervalMinutes;
  // クライアント側のフィード取得日時
  final DateTime lastModified;
  FetchFeedRequest({
    required this.siteUrl,
    required this.intervalMinutes,
    required this.lastModified,
  });
}

enum FetchArticlesRequestType {
  // サイトの最新記事を100件を上限に取得
  latest,
  // クライアント側記事最古日時より古い記事の取得
  old,
  // クライアント側記事最新日時より新しい記事を取得して更新
  update,
}
