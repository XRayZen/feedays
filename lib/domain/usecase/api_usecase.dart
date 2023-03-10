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
  

}
