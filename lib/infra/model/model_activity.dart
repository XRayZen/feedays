
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
