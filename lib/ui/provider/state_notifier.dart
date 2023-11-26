import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultProvider =
    StateNotifierProvider<SearchResultNotifier, SearchResult>((ref) {
  return SearchResultNotifier();
});

class SearchResultNotifier extends StateNotifier<SearchResult> {
  SearchResultNotifier()
      : super(
          SearchResult(
            apiResponse: ApiResponseType.refuse,
            responseMessage: 'Default',
            resultType: SearchResultType.none,
            searchType: SearchType.keyword,
            websites: [],
            articles: [],
          ),
        );

  void add(SearchResult res) {
    state = res;
  }

  void clear() {
    state = SearchResult(
      apiResponse: ApiResponseType.refuse,
      responseMessage: 'Default',
      resultType: SearchResultType.none,
      searchType: SearchType.keyword,
      websites: [],
      articles: [],
    );
  }
}
