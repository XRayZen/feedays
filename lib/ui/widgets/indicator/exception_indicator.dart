import 'package:flutter/material.dart';

/// 例外が発生したことを示すための基本レイアウト。
class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    required this.title,
    required this.assetName,
    this.message='',
    this.onTryAgain,
    super.key,
  });
  final String title;
  final String message;
  final String assetName;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            children: [
              Image.asset(
                assetName,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (message != '')
                const SizedBox(
                  height: 16,
                ),
              if (message != '')
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              if (onTryAgain != null) const Spacer(),
              onTry(onTryAgain)
            ],
          ),
        ),
      );

  Widget onTry(VoidCallback? isOnTry) {
    if (isOnTry!=null) {
      return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTryAgain,
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          label: const Text(
            'Try Again',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return const Spacer();
    }
  }
}
