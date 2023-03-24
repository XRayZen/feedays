import 'package:feedays/infra/model/hive_ctrl.dart';
import 'package:feedays/mock/mock_api_repository.dart';
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'ui/page/start_page.dart';

void main({bool isProviderOverRide = true}) async {
  await initLocalDataHandler();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        // これがアプリケーションのテーマです。
        //PLAN:設定で切り替えられるようにする
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
        // colorScheme: const ColorScheme.dark(
        //   primary: Colors.amber,
        //   // secondary: Colors.white54,
        // ),
        fontFamily: 'Noto Sans JP',
        useMaterial3: true,
      ),
      // ignore: prefer_const_constructors
      home: StartPageView(),
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        // maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(
            1000, name: DESKTOP, scaleFactor: 1,
            // 0.90,
          ),
          const ResponsiveBreakpoint.autoScale(
            1200,
            name: DESKTOP,
            scaleFactor:
                // 1,
                0.70,
          ),
          // const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        background: Container(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      initialRoute: '/',
    );
  }
}
