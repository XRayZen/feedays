import 'package:feedays/domain/entities/explore_web.dart';
import 'package:hive/hive.dart';

part 'model_explore.g.dart';

@HiveType(typeId: 25)
class ModelExploreCategory extends HiveObject {
  ModelExploreCategory({
    required this.name,
    required this.iconLink,
  });
  factory ModelExploreCategory.from(ExploreCategory cat) {
    return ModelExploreCategory(name: cat.name, iconLink: cat.iconLink);
  }
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String iconLink;
}
