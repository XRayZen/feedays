import 'package:feedays/domain/usecase/rss_feed_usecase.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('description', () {
    test('feed parse test', () {
      final webRepo = WebRepoImpl();
      final usecase = RssFeedUsecase(webRepo: webRepo);
      
    });
  });
}
