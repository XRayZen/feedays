// ignore_for_file: avoid_positional_boolean_parameters

import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/api_response.dart';
import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/entity.dart';
import 'package:feedays/domain/entities/explore_web.dart';
import 'package:feedays/domain/entities/search.dart';
import 'package:feedays/domain/entities/web_sites.dart';

abstract class BackendApiRepository {
  // Read系
  Future<List<ExploreCategory>> getExploreCategories(
    UserAccessIdentInfo identInfo,
  );
  Future<RankingResponse> getRanking(
    String userID,
    UserAccessIdentInfo identInfo,
  );

  /// Write系
  //初回起動時にユーザーIDを取得する
  Future<String> getNewUserID(UserAccessIdentInfo identInfo);
  // 起動時に最新の設定を取得して同期する
  // マルチプラットフォームで設定を同期するためのコード同期にも使う
  Future<UserConfig> syncConfig(String userID, UserAccessIdentInfo identInfo);
  //UserConfigと購読していたサイトを取得して同期する同期する
  Future<APIResponse> userRegister(
    UserConfig cfg,
    UserAccessIdentInfo identInfo,
  );
  //閲覧などのアクテビティを報告する
  Future<APIResponse> reportReadActivity(
    ReadActivity activity,
    UserAccessIdentInfo identInfo,
  );
  //設定を同期する UI設定を変更したらクラウドに送信してクラウドの設定を上書きする
  Future<APIResponse> updateConfig(
    UserConfig cfg,
    UserAccessIdentInfo identInfo,
  );
  // 検索履歴を追加・削除する
  // リターンはString配列
  Future<List<String>> modifySearchHistory(
    String text, {
    bool isAddOrRemove = true,
  });
  //サイトをお気に入りに登録・解除する
  Future<APIResponse> favoriteSite(
    String userID,
    WebSite site,
    bool isFavorite,
  );
  //記事をお気に入りに登録・解除する
  Future<APIResponse> favoriteArticle(
    String userID,
    Article article,
    bool isFavorite,
  );
  //APIリクエスト制限を取得する
  Future<ApiRequestLimitConfig> getApiRequestLimit(
    String userID,
    UserAccessIdentInfo identInfo,
  );

  ///ネットから情報を収集する重い処理
  Future<SearchResult> searchWord(ApiSearchRequest request);
  //サイトを購読・購読解除する
  Future<APIResponse> subscribeSite(WebSite site, bool isSubscribe);
  //クラウドフィードサイトの取得・更新を問い合わせる
  Future<FetchCloudFeedResponse> fetchCloudFeed(String url);
}
