// ignore_for_file: public_member_api_docs, sort_constructors_first
//TODO:複雑化したのでUseCaseをリファクタリングする

import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/domain/repositories/api/backend_repository_interface.dart';
import 'package:feedays/domain/repositories/local/local_repository_interface.dart';
import 'package:feedays/domain/repositories/web/web_repository_interface.dart';
import 'package:feedays/domain/usecase/api_usecase.dart';
import 'package:feedays/domain/usecase/config_usecase.dart';
import 'package:feedays/domain/usecase/rss_usecase.dart';
import 'package:feedays/util.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Usecase {
  final WebRepositoryInterface webRepo;
  final BackendApiRepository apiRepo;
  final LocalRepositoryInterface localRepo;
  Future<void> Function(String message) noticeError;
  Future<void> Function(WebSite site) onAddSite;
  void Function(int count, int all, String msg) progressCallBack;
  late UserConfig userCfg;
  late WebFeedData rssFeedData;
  late ConfigUsecase configUsecase;
  late RssUsecase rssUsecase;
  late ApiUsecase apiUsecase;
  Usecase({
    required this.webRepo,
    required this.apiRepo,
    required this.localRepo,
    required this.onAddSite,
    required this.progressCallBack,
    required this.noticeError,
  });

  /// 起動時の処理
  Future<void> init() async {
    //起動時にデータを読み込む
    await localRepo.init();
    final configData = await localRepo.readConfig();
    if (configData != null) {
      userCfg = configData;
    } else {
      //データが無かったら起動初回処理
      //ユーザー情報を取得してApiでユーザー登録してデータを用意する
      userCfg = UserConfig.defaultUserConfig();
    }
    final rssFeedSites = await localRepo.readFeedData();
    if (rssFeedSites != null) {
      rssFeedData = rssFeedSites;
    } else {
      //データが無かったら起動初回処理
      //データを用意する
      rssFeedData = WebFeedData(folders: []);
    }
    //インスタンス化
    configUsecase = ConfigUsecase(
      localRepo: localRepo,
      userCfg: userCfg,
    );
    apiUsecase = ApiUsecase(
      backendApiRepo: apiRepo,
      noticeError: noticeError,
      userCfg: userCfg,
      //ユーザーデバイス識別情報はここで取得
      identInfo: await localRepo.getDevice(),
    );
    rssUsecase = RssUsecase(
      webRepo: webRepo,
      apiRepo: apiRepo,
      localRepo: localRepo,
      apiUsecase: apiUsecase,
      noticeError: noticeError,
      onAddSite: onAddSite,
      progressCallBack: progressCallBack,
      rssFeedData: rssFeedData,
      userCfg: userCfg,
    );
  }
}
