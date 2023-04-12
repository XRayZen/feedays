// ignore_for_file: public_member_api_docs, sort_constructors_first
//PLAN:flutterのアクティビティのやり方/Best Practiceを調べる

class UserReadActivity {
  final String userID;
  final String title;
  final String link;
  UserReadActivity({
    required this.userID,
    required this.title,
    required this.link,
  });
}

class UserSubscribeActivity {
  final String userID;
  final String ip;
  final String title;
  final String link;
  final String category;
  final List<String> tags;
  UserSubscribeActivity({
    required this.userID,
    required this.ip,
    required this.title,
    required this.link,
    required this.category,
    required this.tags,
  });
}

///ユーザーがアクセスした端末の情報
///Apiにリクエストする際に生成して送信する
class UserAccessIdentInfo {
  final String uUid; //端末で取得出来たら
  final UserAccessPlatform accessPlatform;
  final UserPlatformType platformType;
  final String brand;
  final String deviceName;
  //OSのバージョン
  final String osVersion;
  final bool isPhysics;
  UserAccessIdentInfo({
    required this.uUid,
    required this.accessPlatform,
    required this.platformType,
    required this.brand,
    required this.deviceName,
    required this.osVersion,
    required this.isPhysics,
  });
}

enum UserAccessPlatform { pc, web, mobile, other }

enum UserPlatformType { android, ios, windows, mac, linux, web, other }
