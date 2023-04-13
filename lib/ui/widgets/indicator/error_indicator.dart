import 'dart:io';

import 'package:flutter/material.dart';

import 'generic_error_indicator.dart';
import 'no_connection_indicator.dart';

/// 受信したエラーに基づいて、[NoConnectionIndicator]または[GenericErrorIndicator]を表示する。
/// GenericErrorIndicator]のいずれかを表示する。
class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    required this.error,
    required this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final dynamic error;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => error is SocketException
      ? NoConnectionIndicator(
          onTryAgain: onTryAgain,
        )
      : GenericErrorIndicator(
          onTryAgain: onTryAgain,
        );
}
