// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanView extends ConsumerStatefulWidget {
  void Function(String? code) code;
  QRScanView({
    super.key,
    required this.code,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QRScanViewState();
}

class _QRScanViewState extends ConsumerState<QRScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // ホットリロードを動作させるためには、プラットフォームがアンドロイドの場合はカメラを一時停止し、
  // プラットフォームがiOSの場合はカメラを再開する必要があります。
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      // ここで、スキャンされたコードを処理します。
      //ApiUsecaseを呼び出して同期する
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scan'),
        centerTitle: true,
      ),
      //PCプラットフォームでは、カメラを使えないので別の表示にする
      body: Platform.isAndroid || Platform.isIOS
          ? _buildQrView(context)
          : const Center(
              child: Text('PCプラットフォームではカメラを使えません。'),
            ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // この例では、デバイスの幅や高さを確認し、それに応じてscanAreaとオーバーレイを変更します。
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // 回転後のスキャナビューのサイズを適切に設定するため
    // FlutterのSizeChanged通知をリスニングし、コントローラを更新する必要があります。
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }
}
