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
