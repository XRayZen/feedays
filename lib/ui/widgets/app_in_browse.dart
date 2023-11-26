import 'dart:async';

import 'package:feedays/ui/provider/ui_provider.dart';
import 'package:feedays/ui/ui_util.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppInWebBrowse extends ConsumerStatefulWidget {
  const AppInWebBrowse({
    super.key,
    required this.url,
  });
  final String url;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppInWebBrowseState();
}

class _AppInWebBrowseState extends ConsumerState<AppInWebBrowse> {
  //参考元: https://virment.com/how-to-show-webview-in-flutter-app/
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late final WebViewController controller;

  bool _isLoading = false; // ページ読み込み状態
  double _downloadProgress = 0; // ページ読み込みの進捗値
  int _progress = 0;
  bool isError = false;
  String errorMessage = '';
  String _url = '';

  @override
  void initState() {
    super.initState();
    _url = widget.url;

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          // ページへの遷移処理開始時の処理 特定のURLを拒否できる
          onNavigationRequest: (request) => NavigationDecision.navigate,
          onProgress: (progress) {
            setState(() {
              _downloadProgress = progress / 100;
              _progress = progress;
            });
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
          onWebResourceError: (error) {
            setState(() {
              _isLoading = true;
              _downloadProgress = 0;
              _progress = 0;
              isError = true;
              errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri(path: _url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //Androidなら有効だが、iOSでは透明にできない
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        centerTitle: true,
        title: Text(
          _url,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: getResponsiveValue(
              context,
              mobileValue: 15,
              tabletValue: 22,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: () async {
              //リロード
              final controller = await _controller.future;
              await controller.reload();
            },
            icon: const Icon(Icons.replay_outlined),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  //シェアポップアップを呼び出す
                  callShare(
                    context,
                    widget.url,
                    'Share this Site',
                  );
                },
                icon: const Icon(Icons.share_sharp),
              );
            },
          ),
          IconButton(
            tooltip: 'Open in Browser',
            onPressed: () async {
              //外部ブラウザで開く
              await launchWebUrl(widget.url);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: Column(
        children: [
          // ページ読み込み中のプログレスバー
          _isLoading || _downloadProgress < 1.0 || _progress < 100
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: _downloadProgress,
                    ),
                    Text(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getResponsiveValue(context),
                      ),
                      'Web site is loading... (Progress : $_progress%)',
                    )
                  ],
                )
              : isError
                  ? Text(
                      'HTTP Request Error: $errorMessage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getResponsiveValue(context),
                      ),
                    )
                  : const SizedBox.shrink(),
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
