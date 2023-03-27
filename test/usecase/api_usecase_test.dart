
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Search Word',
    () async {
      final webRepo = WebRepoImpl();
      const path = 'http://blog.esuteru.com/index.rdf';
      final res = await webRepo.getFeeds(path);
      expect(res, isNotEmpty);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
