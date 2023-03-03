// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';
//#enddocregion platform_imports

class AppInWebBrowse extends ConsumerStatefulWidget {
  final Uri url;
  const AppInWebBrowse({
    super.key,
    required this.url,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppInWebBrowseState();
}

class _AppInWebBrowseState extends ConsumerState<AppInWebBrowse> {
  //参考元: https://virment.com/how-to-show-webview-in-flutter-app/
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late final WebViewController controller;

  bool _isLoading = false; // ページ読み込み状態
  double _downloadProgress = 0.0; // ページ読み込みの進捗値
  int _progress = 0;
  String _url = '';

  @override
  void initState() {
    super.initState();
    _url = widget.url.toString();

    if (UniversalPlatform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              //リロード
              final controller = await _controller.future;
              await controller.reload();
            },
            icon: Icon(Icons.replay_outlined),
          ),
          IconButton(
            onPressed: () {
              //シェアポップアップを呼び出す
            },
            icon: Icon(Icons.share_sharp),
          ),
          IconButton(
            onPressed: () async {
              //外部ブラウザで開く
              await launchWebUrl(widget.url);
            },
            icon: Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading
              ? Stack(
                  children: [
                    LinearProgressIndicator(
                      value: _downloadProgress,
                    ),
                    Center(
                      child: Flexible(
                        child: Text(
                          'Web site is loading... (Progress : $_progress%)',
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox.shrink(),
          Expanded(
            child: WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: _controller.complete,
              onProgress: (progress) {
                setState(() {
                  _downloadProgress = progress / 100;
                  _progress = progress;
                });
              },
              // ページへの遷移処理開始時の処理 特定のURLを拒否できる
              navigationDelegate: (navigation) {
                return NavigationDecision.navigate;
              },
              onPageStarted: (url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (url) async {
                setState(() {
                  _isLoading = false;
                });
              },
              //IOSのみ対応
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
          ),
        ],
      ),
    );
  }
}
