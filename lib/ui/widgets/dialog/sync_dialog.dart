// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final BuildContext context;
  SyncDialogWidget({
    required this.context,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SyncDialogWidgetState();
}

class _SyncDialogWidgetState extends ConsumerState<SyncDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(widget.context).size;
    return SafeArea(
      child: Container(
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
                rowMainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.2,
                      color: Colors.red,
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    rowFlex: 1,
                    child: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.2,
                      color: Colors.blue,
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
