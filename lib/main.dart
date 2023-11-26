import 'package:feedays/mock/mock_api_repository.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'ui/page/start_page.dart';

void main({bool isProviderOverRide = true}) async {
  if (isProviderOverRide) {
    runApp(
      //統合テスト用にプロバイダー上書きを切り替える
      ProviderScope(
        overrides: [
          //但し、この方法だとスタブを臨機応変に変えることは出来ない
          backendApiRepoProvider.overrideWithValue(MockApiRepository())
        ],
        // ignore: prefer_const_constructors
        child: MyApp(),
      ),
    );
  } else {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }
}

GlobalKey<ScaffoldState> startPageScaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        // これがアプリケーションのテーマです。
        //PLAN:設定で切り替えられるようにする
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //ダークテーマ時のカラーを青色にする
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amber,
        ),
        brightness: Brightness.dark,
        fontFamily: 'Noto Sans JP',
        useMaterial3: true,
      ),
      // ignore: prefer_const_constructors
      home: StartPageView(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K')
        ],
      ),
      initialRoute: '/',
    );
  }
}
