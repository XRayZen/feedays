import 'package:feedays/domain/entities/activity.dart';
import 'package:hive/hive.dart';

part 'model_activity.g.dart';

@HiveType(typeId: 22)
class ModelUserReadActivity {
  ModelUserReadActivity({
    required this.userID,
    required this.title,
    required this.link,
  });
  @HiveField(0)
  final String userID;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String link;
}

@HiveType(typeId: 21)
class ModelUserSubscribeActivity {
  ModelUserSubscribeActivity({
    required this.userID,
    required this.ip,
    required this.title,
    required this.link,
    required this.category,
    required this.tags,
  });
  factory ModelUserSubscribeActivity.from(UserSubscribeActivity act) {
    return ModelUserSubscribeActivity(
      userID: act.userID,
      ip: act.ip,
      title: act.title,
      link: act.link,
      category: act.category,
      tags: act.tags,
    );
  }
  @HiveField(0)
  final String userID;
  @HiveField(1)
  final String ip;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String link;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final List<String> tags;
}

@HiveType(typeId: 20)
class ModelUserIdentInfo extends HiveObject {
  ModelUserIdentInfo({
    required this.ip,
    required this.macAddress,
    this.uUid,
    required this.token,
    required this.accessPlatform,
  });
  factory ModelUserIdentInfo.from(UserIdentInfo i) {
    return ModelUserIdentInfo(
      ip: i.ip,
      macAddress: i.macAddress,
      token: i.token,
      accessPlatform: convertUserAccessPlatform(i.accessPlatform),
    );
  }
  @HiveField(0)
  final String ip;
  @HiveField(1)
  final String macAddress;
  @HiveField(2)
  final String? uUid; //端末で取得出来たら
  //初回起動時にサーバーから付与されるパスワードのようなもの
  //サーバーにはそれに対応したSHAハッシュ値のみ登録される
  @HiveField(3)
  final String token;
  @HiveField(4)
  final ModelUserAccessPlatform accessPlatform;
}

ModelUserAccessPlatform convertUserAccessPlatform(UserAccessPlatform i) {
  switch(i){
    case UserAccessPlatform.pc:
      return ModelUserAccessPlatform.pc;
    case UserAccessPlatform.web:
      return ModelUserAccessPlatform.web;
    case UserAccessPlatform.mobile:
      return ModelUserAccessPlatform.mobile;
    case UserAccessPlatform.tablet:
      return ModelUserAccessPlatform.tablet;
  }
}

@HiveType(typeId: 23)
enum ModelUserAccessPlatform { 
  @HiveField(0)
  pc, 
  @HiveField(1)
  web, 
  @HiveField(2)
  mobile, 
  @HiveField(3)
  tablet }
