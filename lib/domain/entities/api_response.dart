import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';

class FetchCloudFeedResponse {
  FetchCloudFeedResponse({
    required this.responseType,
    required this.feeds,
    required this.error,
  });
  final ApiResponseType responseType;
  final List<Article> feeds;
  final String error;
}

//codeSync()のレスポンス
class CodeSyncResponse {
  CodeSyncResponse({
    required this.responseType,
    required this.userConfig,
    required this.webSites,
    required this.error,
  });
  final ApiResponseType responseType;
  final UserConfig userConfig;
  final List<WebSite> webSites;
  final String error;
}
