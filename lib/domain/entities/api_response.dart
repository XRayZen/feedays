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
