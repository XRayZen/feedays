import 'dart:async';

import 'package:feedays/domain/entities/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchRequestProvider =
    AsyncNotifierProvider<SearchNotifier, SearchRequest>(() {
  return SearchNotifier();
});

class SearchNotifier extends AsyncNotifier<SearchRequest> {
  @override
  FutureOr<SearchRequest> build() {
    return SearchRequest(searchType: SearchType.addContent, word: 'word');
  }

  Future<void> add(SearchRequest re) async {
    //Stateの状態を読み込みモードにする
    state = const AsyncValue.loading();
    // stateを更新
    state = AsyncValue.data(re);
  }
}
