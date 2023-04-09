// ignore_for_file:  use_decorated_box
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void showSyncDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          child: SyncDialogWidget(
            context: context,
          ),
        ),
      );
    },
  );
}

class SyncDialogWidget extends ConsumerStatefulWidget {
  const SyncDialogWidget({
    super.key,
    required this.context,
  });
  final BuildContext context;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SyncDialogWidgetState();
}

class _SyncDialogWidgetState extends ConsumerState<SyncDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(widget.context).size;
    return SafeArea(
      child: SizedBox(
        height: size.height * 0.5,
        width: size.width * 0.5,
        child: Card(
          elevation: 8,
          child: Column(
            children: [
              const Text(
                'QR Code Sync',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan the QR code on the other device',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ResponsiveRowColumn(
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                      //白い枠線を描画する
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        title: const Text('Sacn QR Code'),
                        subtitle:
                            const Text('Scan the QR code on the other device'),
                        onTap: () {
                          //TODO: QRコードを読み込む処理を書く
                          //カメラを起動してQRコードを読み込む

                          //読み込んだQRコードを解析する
                          //解析した結果をもとにデータを同期する
                        },
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                      //白い枠線を描画する
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        title: const Text('Show QR Code'),
                        subtitle:
                            const Text('Show the QR code on the other device'),
                        onTap: () {
                          //TODO: QRコードを表示する処理を書く
                          //QRコードを表示する
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SingleChildScrollView(
                                  child: QrImage(
                                    //背景を白くする
                                    backgroundColor: Colors.white,
                                    //QRコードのデータはユーザーIDを使用する
                                    data: 'test',
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
