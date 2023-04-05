// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/domain/entities/app_config.dart';
import 'package:feedays/domain/entities/ui_config.dart';
import 'package:feedays/ui/provider/business_provider.dart';
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

void showFeedDetailDialog(BuildContext context, WidgetRef ref) {
  final appConfig = ref.watch(AppCfgProvider);
  var fontSize = readFontSize(context, ref, appConfig);
  Picker(
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? ThemeData.dark().primaryColor
        : Colors.grey[100],
    title: Text("Please select a font size"),
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
    onConfirm: (Picker picker, List value) {
      //設定UseCaseの該当メソッドに設定内容を渡して更新・永続化する
      ref.watch(useCaseProvider).configUsecase.updateFeedDetailFontSize(
            context,
            fontSize + 1,
          );
      //UI再描画用プロバイダーを呼んでUIを再描画する
      ref.watch(onChangedProvider.notifier).state += 1;
    },
  ).showDialog(context);
}
