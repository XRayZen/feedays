import 'package:feedays/infra/impl_repo/web_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ogpImage', () async {
    const path = 'http://jin115.com/archives/52365485.html';
    final webrepo = WebRepoImpl();
    final response = await webrepo.fetchHttpString(path, isUtf8: true);
    final data = await webrepo.getOGPImageUrl(path);
    expect(data, isNotNull);
  });
}
