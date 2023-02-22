// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:feedays/domain/repositories/local/preferences_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';

class WebImageLoader {
  final WebRepositoryInterface webRepo;
  final PreferencesRepositoryInterface preRepo;
  WebImageLoader({
    required this.webRepo,
    required this.preRepo,
  });
  Future<ByteData?> getImageCache(String url) async {
    //urlをキーにローカルにファイルがないのなら
    var find_pre = await preRepo.findKey(url);
    if (find_pre.isNotEmpty) {
      //存在するのなら
      if (find_pre.values.isNotEmpty) {
        return find_pre.values.first as ByteData;
      }else{
        return null;
      }
    } else {
      final data = await webRepo.fetchHttpByteData(url);
      
    }
  }
}
