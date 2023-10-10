import 'dart:typed_data';

import 'package:feedays/domain/entities/web_sites.dart';


// APIに渡すユーザー設定には購読するサイトのリストが含まれる
class ApiModelSubscribeWebSite{
  ApiModelSubscribeWebSite({
    required this.folderIndex,
    required this.folderName,
    required this.siteIndex,
    required this.site,
  });
  final int folderIndex;
  final String folderName;
  final int siteIndex;
  final WebSite site;
}

class APIWebSite{
  
}
