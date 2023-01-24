import 'package:flutter/material.dart';

import 'ui/page/start_page.dart';

void main() {
  runApp(const MyApp());
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(), // ダーク用テーマ
      themeMode: ThemeMode.dark,
      home: const StartPage(title: 'Flutter Demo Home Page'),
    );
  }
}
