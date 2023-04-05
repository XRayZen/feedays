// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feedays/ui/provider/config_provider.dart';
import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HtmlViewWidget extends ConsumerStatefulWidget {
  final String data;
  const HtmlViewWidget({
    super.key,
    required this.data,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HtmlViewState();
}

class _HtmlViewState extends ConsumerState<HtmlViewWidget> {
  @override
  Widget build(BuildContext context) {
    final appConfig = ref.watch(AppCfgProvider);
    final fontSite =
        getFontSize(context, appConfig.uiConfig.feedDetailFontSize);
    return Html(
      shrinkWrap: true,
      data: widget.data,
      style: {
        'body': Style(
          fontSize: FontSize(fontSite),
        )
      },
    );
  }
}
