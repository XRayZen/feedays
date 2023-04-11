// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/util.dart';

class ApiUsecase {
  final BackendApiRepository backendApiRepo;
  UserConfig userCfg;
  ApiUsecase({
    required this.backendApiRepo,
    required this.userCfg,
  });

  String getSyncCode() {
    //今は同期コードはユーザーIDを返す
    return userCfg.userID;
  }

  void codeSync(String? code) {
    //Apiにリクエストして設定を受け取り、上書き更新する
  }
}
