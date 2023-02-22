import 'package:feedays/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlWidget extends StatelessWidget {
  const HtmlWidget({super.key, required this.data});
  final String data;
  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        'body': Style(
          fontSize: FontSize(
            getResponsiveValue(
              context,
              defaultValue: 15,
              mobileValue: 18,
              tabletValue: 14,
            ),
          ),
        )
      },
    );
  }
}
