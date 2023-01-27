// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import '../../domain/entities/entity.dart';

class FeedModel {
  final String key;
  final String name;
  final String url;
  final ByteData? icon;
  final int newCount;
  final String category;
  FeedModel({
    required this.key,
    required this.name,
    required this.url,
    this.icon,
    required this.newCount,
    required this.category,
  });
  //ファクトリーコンストラクタの名前は、直前のクラスの名前と同じでなければなりません。
  factory FeedModel.from(WebSite site) {
    return FeedModel(
      key: site.key,
      name: site.name,
      url: site.url,
      newCount: site.newCount,
      category: site.category,
      icon: site.icon,
    );
  }
}
