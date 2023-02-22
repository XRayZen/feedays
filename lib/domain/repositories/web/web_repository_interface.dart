import 'dart:typed_data';

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_meta.dart';

abstract class WebRepositoryInterface {
  Future<WebSite> getFeeds(WebSite site);
  Future<WebSite?> fetchSiteOgpMeta(String url);
  Future<String?> getOGPImageUrl(String url);
  Future<String> fetchHttpString(String url);
  Future<ByteData> fetchHttpByteData(String url);
  
}
