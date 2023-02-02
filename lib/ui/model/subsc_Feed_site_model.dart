// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import '../../domain/entities/entity.dart';

class SubscFeedSiteModel {
  final String key;
  final String name;
  final String url;
  final ByteData? icon;
  final int newCount;
  final String category;
  final CategoryOrSite categoryOrSite;
  final List<SubscFeedSiteModel> nodes;
  SubscFeedSiteModel({
    required this.key,
    required this.name,
    required this.url,
    this.icon,
    required this.newCount,
    required this.category,
    required this.categoryOrSite,
    required this.nodes,
  });

  //ファクトリーコンストラクタの名前は、直前のクラスの名前と同じでなければなりません。
  factory SubscFeedSiteModel.from(WebSite site) {
    return SubscFeedSiteModel(
        key: site.key,
        name: site.name,
        url: site.url,
        newCount: site.newCount,
        category: site.category,
        icon: site.icon,
        categoryOrSite: CategoryOrSite.site,
        nodes: []);
  }
}

enum CategoryOrSite { category, site }
