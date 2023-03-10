//UIのコントローラーなどUIロジックを集める

import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/widgets/app_in_browse.dart';
import 'package:feedays/ui/widgets/snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

///UIの再描画メソッドを集めるクラス
class UiProvider {
  // インスタンスを1つしか生成しないようにするため
  // シングルトン化する
  UiProvider._();
  static final instanceO = UiProvider._();

  late Function rebuildSiteDeatailPage;
  void setRebuildSiteDetailPage(Function func) {
    rebuildSiteDeatailPage = func;
  }

  void beginRebuildSiteDetailPage() {
    rebuildSiteDeatailPage();
  }
}

class ReTryRssFeedNotifier extends Notifier<WebSite> {
  @override
  WebSite build() => WebSite.mock('', '', '');

  Future<void> retry(BuildContext context, WebSite site) async {
    try {
      state = WebSite.mock('', '', '');
      final response = await ref.watch(webUsecaseProvider).fetchRssFeed(site);
      showSnack(context, 2000, 'Success! Refresh Rss');
      state = response;
    } on Exception catch (e) {
      //エラーが出てリトライ処理が失敗したらスナックバーで表示する
      showSnack(context, 2000, e.toString());
    }
  }
}

final reTryRssFeedProvider =
    NotifierProvider<ReTryRssFeedNotifier, WebSite>(ReTryRssFeedNotifier.new);

Future<void> launchWebUrl(
  String url, {
  BuildContext? context,
  Widget? widget,
}) async {
  if (context != null && widget != null) {
    await Navigator.of(context).push(
      PageTransition(
        child: AppInWebBrowse(url: url),
        type: PageTransitionType.theme,
        childCurrent: widget,
      ),
    );
  } else {
    if (!await launchUrl(
      mode: LaunchMode.externalApplication,
      Uri.parse(url),
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

