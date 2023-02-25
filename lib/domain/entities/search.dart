// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';

import 'activity.dart';

class SearchRequest {
  final SearchType searchType;
  final String word;
  SearchRequest({
    required this.searchType,
    required this.word,
  });
}

class ApiSearchRequest {
  final SearchType searchType;
  final SearchQueryType queryType;
  final String word;
  final String userID;
  final UserIdentInfo identInfo;
  final UserAccountType accountType;
  ApiSearchRequest({
    required this.searchType,
    required this.queryType,
    required this.word,
    required this.userID,
    required this.identInfo,
    required this.accountType,
  });
}

enum SearchQueryType { url, word }

enum SearchType { addContent, powerSearch }

enum SearchResultType { found, none, error }

class SearchResult {
  final ApiResponseType apiResponse;
  final String responseMessage;
  final SearchResultType resultType;
  Exception? exception;

  ///AddContentならサイトを返す<br/>
  ///PowerSearchなら記事を返す
  SearchType searchType;
  final List<WebSite> websites;
  List<RssFeedItem> articles;
  SearchResult({
    required this.apiResponse,
    required this.responseMessage,
    required this.resultType,
    required this.searchType,
    required this.websites,
    required this.articles,
  });
}
