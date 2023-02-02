import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

///レスポンシブ対応のテキストスタイルを生成
TextStyle genResponsiveTextStyle(
    BuildContext context,
    double mobileValue,
    double tabletValue,
    double? letterSpacing,
    FontWeight? fontWeight,
    Color? color) {
  final value = ResponsiveValue(
    context,
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
      fontWeight: fontWeight);
}

double getResponsiveValue(
  BuildContext context,
  double defaultValue,
  double mobileValue,
  double tabletValue,
) {
  var res = ResponsiveValue(
    context,
    defaultValue: defaultValue,
    valueWhen: [
      //MOBILE より小さい場合はフォントサイズがvalue  になる
      Condition.smallerThan(name: MOBILE, value: mobileValue),
      // TABLET より大きい場合はフォントサイズが value になる
      Condition.largerThan(name: TABLET, value: tabletValue)
    ],
  ).value;
  return res ?? defaultValue;
}
