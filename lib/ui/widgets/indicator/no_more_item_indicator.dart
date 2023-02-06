import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoMoreItemIndicator extends ConsumerWidget {
  const NoMoreItemIndicator({super.key, required this.onTryAgain});
  final Function onTryAgain;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('No more item'),
        Image.asset(
          'assets/empty-box.png',
        ),
        TextButton(
          child: const Text('Retry'),
          onPressed: () => onTryAgain,
        ),
      ],
    );
  }
}
