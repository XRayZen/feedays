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

class UserIdentInfo {
  final String ip;
  final String macAddress;
  final String? uUid; //端末で取得出来たら
  //初回起動時にサーバーから付与されるパスワードのようなもの
  //サーバーにはそれに対応したSHAハッシュ値のみ登録される
  final String token;
  final UserAccessPlatform accessPlatform;
  UserIdentInfo({
    required this.ip,
    required this.macAddress,
    this.uUid,
    required this.token,
    required this.accessPlatform,
  });
}

enum UserAccessPlatform { pc, web, mobile, tablet }
