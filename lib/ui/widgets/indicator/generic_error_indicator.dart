import 'package:flutter/cupertino.dart';

import 'exception_indicator.dart';

/// Indicates that an unknown error occurred.
class GenericErrorIndicator extends StatelessWidget {
  const GenericErrorIndicator({
    super.key,
    required this.onTryAgain,
  });

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => ExceptionIndicator(
        title: 'Something went wrong',
        message: 'The application has encountered an unknown error.\n'
            'Please try again later.',
        assetName: 'assets/confused-face.png',
        onTryAgain: onTryAgain,
      );
}
