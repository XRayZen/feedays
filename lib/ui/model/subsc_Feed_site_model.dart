import 'package:feedays/domain/entities/web_sites.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/entity.dart';

class SubscFeedSiteModel {
  //ファクトリーコンストラクタの名前は、直前のクラスの名前と同じでなければなりません。
  factory SubscFeedSiteModel.from(WebSite site) {
    return SubscFeedSiteModel(
      key: site.key,
      name: site.name,
      siteUrl: site.siteUrl,
      newCount: site.newCount,
      category: site.category,
      icon: site.icon,
      categoryOrSite: CategoryOrSite.site,
      nodes: [],
    );
  }
  final String key;
  final String name;
  final String siteUrl;
  final ByteData? icon;
  final int newCount;
  final String category;
  final CategoryOrSite categoryOrSite;
  final List<SubscFeedSiteModel> nodes;
  SubscFeedSiteModel({
    required this.key,
    required this.name,
    required this.siteUrl,
    this.icon,
    required this.newCount,
    required this.category,
    required this.categoryOrSite,
    required this.nodes,
  });
}

enum CategoryOrSite { category, site }
