//UIのコントローラーなどUIロジックを集める

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
