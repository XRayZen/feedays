import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:feedays/domain/entities/activity.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    conditionalValues: [
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
    conditionalValues: [
      //MOBILE より小さい場合はフォントサイズがvalue  になる
      Condition.smallerThan(name: MOBILE, value: mobileValue),
      //TABLET より大きい場合はフォントサイズが value になる
      Condition.largerThan(name: TABLET, value: tabletValue)
    ],
  ).value;
  return res ?? defaultValue;
}

//デバイスタイプに応じてフォントサイズを返す
double getFontSize(BuildContext context, UiResponsiveFontSize size) {
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

//uiConfigのテーマモードに基づいてBrightnessを返す
Brightness getBrightness(UiConfig uiConfig) {
  switch (uiConfig.themeMode) {
    case AppThemeMode.light:
      return Brightness.light;
    case AppThemeMode.dark:
      return Brightness.dark;
    case AppThemeMode.system:
      return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }
}

///今の解像度からモバイルかタブレットかPCかを判定する関数
///関数名をよりわかりやすくしたい
DeviceType howDeviceType(BuildContext context) {
  if (ResponsiveBreakpoints.of(context).smallerThan(MOBILE)) {
    return DeviceType.mobile;
  } else if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
    return DeviceType.tablet;
  } else {
    return DeviceType.pc;
  }
}

bool isMobile(BuildContext context) {
  return ResponsiveBreakpoints.of(context).smallerThan(MOBILE);
}

bool isTablet(BuildContext context) {
  return ResponsiveBreakpoints.of(context).smallerThan(TABLET);
}

bool isDesktop(BuildContext context) {
  return ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
}

UserPlatformType detectPlatformType() {
  if (kIsWeb) {
    return UserPlatformType.web;
  } else if (Platform.isAndroid) {
    return UserPlatformType.android;
  } else if (Platform.isIOS) {
    return UserPlatformType.ios;
  } else if (Platform.isLinux) {
    return UserPlatformType.linux;
  } else if (Platform.isMacOS) {
    return UserPlatformType.mac;
  } else if (Platform.isWindows) {
    return UserPlatformType.windows;
  } else {
    return UserPlatformType.other;
  }
}

UserAccessPlatform detectAccessPlatformType() {
  if (kIsWeb) {
    return UserAccessPlatform.web;
  } else if ((Platform.isAndroid) || (Platform.isIOS)) {
    return UserAccessPlatform.mobile;
  } else if ((Platform.isLinux) || (Platform.isMacOS) || (Platform.isWindows)) {
    return UserAccessPlatform.pc;
  }  else {
    return UserAccessPlatform.pc;
  }
}

///実行しているデバイスの情報を取得する
Future<Map<String, dynamic>> detectDeviceInfo() async {
  var deviceData = <String, dynamic>{};
  final deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (kIsWeb) {
      deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    } else {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      } else if (Platform.isLinux) {
        deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
      } else if (Platform.isMacOS) {
        deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
      } else if (Platform.isWindows) {
        deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
      }
    }
    return deviceData;
  } on PlatformException {
    throw Exception('Failed to get platform version.');
  }
}
//以下は省略している

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'OS.Version': build.version.release,
    'brand': build.brand,
    'device': build.device,
    //UUID
    'UUID': build.id,
    'isPhysicalDevice': build.isPhysicalDevice,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  final sysName = data.systemName;
  final sysVersion = data.systemVersion;
  return <String, dynamic>{
    'OS.Version': '$sysName: $sysVersion',
    'brand': 'Apple',
    'device': data.model,
    //UUID
    'UUID': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
  };
}

Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'OS.Version': data.version,
    'brand': data.prettyName+' : '+data.name,
    'device': data.id,
  };
}

Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'OS.Version': data.userAgent,
    'brand': data.vendor,
    'device': data.platform,
  };
}

Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'OS.Version': data.majorVersion,
    'brand': 'Apple',
    'device': data.model,
  };
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'OS.Version': data.majorVersion,
    'brand': 'Microsoft',
    'device': data.productName,
  };
}
