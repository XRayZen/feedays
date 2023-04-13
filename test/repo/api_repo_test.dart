import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test mock word category', () async {
    const path = 'http://jin115.com/archives/52365485.html';
    final repo = MockApiRepository();
    final cfg = UserConfig.defaultUserConfig();
    final res = await repo.searchWord(
      ApiSearchRequest(
        searchType: SearchType.addContent,
        userID: '',
        requestTime: DateTime.now().toUtc(),
        word: 'News',
        accountType: UserAccountType.guest,
        identInfo: UserAccessIdentInfo(
          brand: 'test',
          accessPlatform: UserAccessPlatform.mobile,
          platformType: UserPlatformType.android,
          uUid: 'test',
          deviceName: 'test',
          osVersion: 'test',
          isPhysics: false,
        ),
      ),
    );
    expect(res.websites.isNotEmpty, true);
  });
}
