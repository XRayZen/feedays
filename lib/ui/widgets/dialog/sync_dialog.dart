// ignore_for_file:  use_decorated_box
import 'package:feedays/ui/provider/business_provider.dart';
import 'package:feedays/ui/widgets/qr_scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void showSyncDialog(BuildContext context) {
  showDialog<void>(
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
                '他のデバイスと設定を同期する',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ResponsiveRowColumn(
                layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
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
                        title: const Text('Scan QR Code'),
                        subtitle:
                            const Text('Scan the QR code on the other device'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => QRScanView(
                                code: (code) {
                                  ref
                                      .watch(useCaseProvider)
                                      .apiUsecase
                                      .codeSync(code);
                                  //QRコードを読み込んだら戻る
                                  Navigator.of(context).pop();
                                  //解析した結果をもとにデータを同期したら戻す
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: ShowQRCodeWidget(ref: ref),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text('PC版ではQRコードを読み込むことができません'),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowQRCodeWidget extends StatelessWidget {
  const ShowQRCodeWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      //白い枠線を描画する
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: ListTile(
        title: const Text('Show QR Code'),
        subtitle: const Text(
          '他のデバイス上のfeedaysにこのQRコードを読み込ませれば設定データを同期できます',
        ),
        onTap: () {
          //QRコードを表示する
          showDialog<void>(
            context: context,
            builder: (context) {
              return Dialog(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'QR Code',
                        style: TextStyle(fontSize: 40),
                      ),
                      QrImageView(
                        //背景を白くする
                        backgroundColor: Colors.white,
                        //QRコードのデータはユーザーIDを使用する
                        data:
                            ref.watch(useCaseProvider).apiUsecase.getSyncCode(),
                        size: 200,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
