import 'package:feedays/domain/entities/entity.dart';
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
            searchType: SearchType.addContent,
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
      searchType: SearchType.addContent,
      websites: [],
      articles: [],
    );
  }
}
