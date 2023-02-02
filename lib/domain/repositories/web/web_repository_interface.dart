import 'package:feedays/domain/entities/entity.dart';

abstract class WebRepositoryInterface {
  Future<WebSite> getFeeds(WebSite site);
}
