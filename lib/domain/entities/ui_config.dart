// ignore_for_file: public_member_api_docs, sort_constructors_first

//アプリのUI設定クラス
class UiConfig {
  int themeColorValue;
  AppThemeMode themeMode;
  double drawerMenuOpacity;
  UiResponsiveFontSize siteFeedListFontSize;
  UiResponsiveFontSize feedDetailFontSize;
  UiConfig({
    required this.themeColorValue,
    required this.themeMode,
    required this.feedDetailFontSize,
    required this.drawerMenuOpacity,
    required this.siteFeedListFontSize,
  });
}

class UiResponsiveFontSize {
  double mobile;
  double tablet;
  double defaultSize;
  UiResponsiveFontSize({
    required this.mobile,
    required this.tablet,
    required this.defaultSize,
  });
}

enum AppThemeMode {
  light,
  dark,
  system,
}

//解像度がタブレットかPCかモバイルかの種類を示すenum
enum DeviceType {
  mobile,
  tablet,
  pc,
}
