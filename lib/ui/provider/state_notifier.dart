import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultProvider =
    StateNotifierProvider<SearchResultNotifier, PreSearchResult>((ref) {
  return SearchResultNotifier();
});

class SearchResultNotifier extends StateNotifier<PreSearchResult> {
  SearchResultNotifier()
      : super(
          PreSearchResult(
            apiResponse: ApiResponseType.refuse,
            responseMessage: 'Default',
            resultType: SearchResultType.none,
            searchType: SearchType.addContent,
            websites: [],
            articles: [],
          ),
        );

  void add(PreSearchResult res) {
    state = res;
  }

  void clear() {
    state = PreSearchResult(
      apiResponse: ApiResponseType.refuse,
      responseMessage: 'Default',
      resultType: SearchResultType.none,
      searchType: SearchType.addContent,
      websites: [],
      articles: [],
    );
  }
}
