import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test mock word category', () async {
    const path = 'http://jin115.com/archives/52365485.html';
    final repo = MockApiRepository();
    final cfg = UserConfig.defaultUserConfig();
    final res = await repo.searchWord(
      ApiSearchRequest(
        word: 'News',
        accountType: UserAccountType.guest,
        identInfo: cfg.identInfo,
        queryType: SearchQueryType.word,
        searchType: SearchType.exploreWeb,
        userID: '',
      ),
    );
    expect(res.websites.isNotEmpty, true);
  });
}
