
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

///レスポンシブ対応のテキストスタイルを生成
TextStyle genResponsiveTextStyle(
  BuildContext context,
  double mobileValue,
  double tabletValue,
  double? letterSpacing,
  FontWeight? fontWeight,
  Color? color,
) {
  final value = ResponsiveValue(
    context,
    // ignore: prefer_int_literals
    defaultValue: 25.0,
    valueWhen: [
      //MOBILE より小さい場合はフォントサイズがvalue  になる
      Condition.smallerThan(name: MOBILE, value: mobileValue),
      // TABLET より大きい場合はフォントサイズが value になる
      Condition.largerThan(name: TABLET, value: tabletValue)
    ],
  ).value;
  return TextStyle(
    color: color,
    fontSize: value,
    letterSpacing: letterSpacing,
    fontWeight: fontWeight,
  );
}

double getResponsiveValue(
  BuildContext context, {
  double defaultValue = 10,
  double mobileValue = 20,
  double tabletValue = 15,
}) {
  final res = ResponsiveValue(
    context,
    defaultValue: defaultValue,
    valueWhen: [
      //MOBILE より小さい場合はフォントサイズがvalue  になる
      Condition.smallerThan(name: MOBILE, value: mobileValue),
      //TABLET より大きい場合はフォントサイズが value になる
      Condition.largerThan(name: TABLET, value: tabletValue)
    ],
  ).value;
  return res ?? defaultValue;
}

//デバイスタイプに応じてフォントサイズを返す
double getFontSize(BuildContext context,UiResponsiveFontSize size) {
  switch (howDeviceType(context)) {
    case DeviceType.mobile:
      return size.mobile;
    case DeviceType.tablet:
      return size.tablet;
    case DeviceType.pc:
      return size.defaultSize;
  }
}

///テキスト内にURLが含まれていたら分割して返す<br/>
///無いならnull
List<String>? parseUrls(String word) {
  final urlRegExp = RegExp(
    r'((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?',
  );
  // ここで、Iterable型でURLの配列を取得
  final urlMatches = urlRegExp.allMatches(word);
  final urls = urlMatches
      .map((urlMatch) => word.substring(urlMatch.start, urlMatch.end))
      .toList();
  if (urls.isEmpty) {
    return null;
  } else {
    return urls;
  }
}

void showDownloadProgress(received, total, msg) {
  if (total != -1) {
    print(msg + (received / total * 100).toStringAsFixed(0) + '%');
  }
}

///今の解像度がモバイルかタブレットかPCかを判定する関数
DeviceType howDeviceType(BuildContext context) {
  if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE)) {
    return DeviceType.mobile;
  } else if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
    return DeviceType.tablet;
  } else {
    return DeviceType.pc;
  }
}

bool isMobile(BuildContext context) {
  return ResponsiveWrapper.of(context).isSmallerThan(MOBILE);
}

bool isTablet(BuildContext context) {
  return ResponsiveWrapper.of(context).isSmallerThan(TABLET);
}

bool isDesktop(BuildContext context) {
  return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP);
}
