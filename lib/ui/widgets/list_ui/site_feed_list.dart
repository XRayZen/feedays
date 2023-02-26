import 'package:feedays/ui/provider/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SiteDetailList extends ConsumerStatefulWidget {
  const SiteDetailList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiteDetailListState();
}

class _SiteDetailListState extends ConsumerState<SiteDetailList> {
  @override
  Widget build(BuildContext context) {
    final site = ref.watch(selectWebSiteProvider);
    return Container();
  }
}
