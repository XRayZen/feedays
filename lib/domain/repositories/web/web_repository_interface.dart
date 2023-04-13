import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';

abstract class WebRepositoryInterface {
  Future<WebSite> getFeeds(
    String url, {
    void Function(int count, int all, String msg)? progressCallBack,
  });
  Future<WebSite> refreshRss(WebSite site, {
    void Function(int count, int all, String msg)? progressCallBack,
  });
  Future<bool> anyPath(String path);
  Future<WebSite> fetchSiteOgpMeta(String url);
  Future<String?> getOGPImageUrl(String url);
  Future<String> fetchHttpString(String url, {bool isUtf8 = false});
  Future<Uint8List> fetchHttpByte(String url);
}
