import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';

enum ApiResponseType { refuse, accept }

class APIResponse {
  APIResponse({
    required this.responseType,
    required this.message,
    required this.error,
  });
  final ApiResponseType responseType;
  final String message;
  final String error;
}

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
class ConfigSyncResponse {
  ConfigSyncResponse({
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

class RankingWebSite {
  RankingWebSite({
    required this.site,
    required this.rank,
  });
  final WebSite site;
  final int rank;
}

// ランキングを取得する
class RankingResponse {
  RankingResponse({
    required this.responseType,
    required this.ranking,
    required this.error,
  });
  final ApiResponseType responseType;
  final List<RankingWebSite> ranking;
  final String error;
}
