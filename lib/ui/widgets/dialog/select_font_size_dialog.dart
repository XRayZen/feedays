import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:feedays/ui/provider/config_provider.dart';
import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//今の解像度がモバイル・タブレット・PCのどれかで設定のフォントサイズを返す
double readFontSize(BuildContext context, WidgetRef ref, AppConfig appConfig) {
  switch (howDeviceType(context)) {
    case DeviceType.mobile:
      return appConfig.uiConfig.feedDetailFontSize.mobile;
    case DeviceType.tablet:
      return appConfig.uiConfig.feedDetailFontSize.tablet;
    case DeviceType.pc:
      return appConfig.uiConfig.feedDetailFontSize.defaultSize;
  }
}

///フォントサイズを変更する汎用的ダイアログを表示する
void showSelectFontSizeDialog(
  BuildContext context,
  WidgetRef ref, {
  ///フォントサイズを変更した後に呼び出すコールバック
  void Function(int value)? confirmCallBack,
}) {
  final appConfig = ref.watch(AppCfgProvider);
  var fontSize = readFontSize(context, ref, appConfig);
  Picker(
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? ThemeData.dark().primaryColor
        : Colors.grey[100],
    title: const Text('Please select a font size'),
    adapter: NumberPickerAdapter(
      data: [
        NumberPickerColumn(
          begin: 1,
          end: 60,
          initValue: fontSize.toInt(),
        ),
      ],
    ),
    textStyle: Theme.of(context).textTheme.titleLarge,
    hideHeader: true,
    onSelect: (picker, index, selected) {
      fontSize = selected[index].toDouble();
    },
    onConfirm: (Picker picker, List<int> value) {
      if (confirmCallBack != null) {
        confirmCallBack(fontSize.toInt() + 1);
      }
      //UI再描画用プロバイダーを呼んでUIを再描画する
      ref.watch(onChangedProvider.notifier).state += 1;
    },
  ).showDialog(context);
}
