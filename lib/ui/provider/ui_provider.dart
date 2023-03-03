//UIのコントローラーなどUIロジックを集める

import 'package:feedays/ui/widgets/app_in_browse.dart';
import 'package:flutter/widgets.dart';
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

Future<void> launchWebUrl(
  Uri url, {
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
      url,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
