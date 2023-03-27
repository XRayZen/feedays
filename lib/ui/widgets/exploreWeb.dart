import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/ui/page/search/custom_text_field.dart';
import 'package:feedays/ui/page/search_view_page.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/provider/rss_provider.dart';
import 'package:feedays/ui/provider/state_notifier.dart';
import 'package:feedays/ui/provider/state_provider.dart';
import 'package:feedays/ui/widgets/indicator/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ExploreWeb extends ConsumerStatefulWidget {
  const ExploreWeb({required this.con, super.key});
  final TextEditingController con;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreWebState();
}

class _ExploreWebState extends ConsumerState<ExploreWeb> {
  @override
  Widget build(BuildContext context) {
    //ビジネスロジック上のカテゴリを読み込んでカテゴリを生成する
    final res = ref.watch(readCategoriesProvider);
    return res.when(
      data: (data) {
        final list = data.map((e) {
          return const ResponsiveRowColumnItem(
            child: Card(),
          );
        }).toList();
        return ResponsiveGridView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          gridDelegate: const ResponsiveGridDelegate(
            crossAxisSpacing: 50,
            mainAxisSpacing: 50,
            minCrossAxisExtent: 150,
          ),
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              leading: Text(item.name),
              onTap: () {
                //TODO:カテゴリを検索する
                //検索ページに遷移してコントローラーにキーワードを入れる
                //検索を実行して表示する
                ref.watch(searchResultViewMode.notifier).state =
                    SearchResultViewMode.none;
                ref.watch(searchResultProvider.notifier).clear();
                ref.watch(barViewTypeProvider.notifier).state =
                    TabBarViewType.searchView;
                setState(() {
                  ref.watch(onTextFieldTapProvider.notifier).state = false;
                  ref.watch(searchTxtFieldProvider.notifier).state = item.name;
                  onSearch(
                    SearchRequest(
                      searchType: SearchType.exploreWeb,
                      word: item.name,
                    ),
                    ref,
                  );
                  ref.watch(isSearchTxtAutoFocus.notifier).state = false;
                  //検索を実行
                });
              },
            );
          },
        );
      },
      error: (error, stackTrace) {
        return ErrorIndicator(
          error: error,
          onTryAgain: () {},
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
