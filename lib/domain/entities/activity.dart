// ignore_for_file: public_member_api_docs, sort_constructors_first
//PLAN:flutterのアクティビティのやり方/Best Practiceを調べる


//TODO:アクテビティをシンプルに一つに統合する
class ReadActivity {
  final String userID;
  final String title;
  final String link;
  final ActivityType type;
  final String siteName;
  final String siteURL;
  final DateTime accessTime;
  final UserAccessPlatform accessPlatform;
  final String accessIP;
  ReadActivity({
    required this.userID,
    required this.title,
    required this.link,
    required this.type,
    required this.siteName,
    required this.siteURL,
    required this.accessTime,
    required this.accessPlatform,
    required this.accessIP,
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

enum ActivityType {
  read,
  subscribe,
  search,
  other,
}
