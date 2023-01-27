import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'ui/page/start_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // これがアプリケーションのテーマです。
        //PLAN:設定で切り替えられるようにする
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // primarySwatch: Colors.amber,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.white54,
        ),
        useMaterial3: true,
      ),
      // darkTheme: ThemeData.dark(useMaterial3: true), // ダーク用テーマ
      themeMode: ThemeMode.system,
      home: const StartPage(title: 'Flutter Demo Home Page'),
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
          background: Container(color: Color.fromARGB(255, 0, 0, 0))),
      initialRoute: "/",
    );
  }
}
