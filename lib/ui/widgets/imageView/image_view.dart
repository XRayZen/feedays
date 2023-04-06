// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:feedays/ui/provider/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///URLを渡してデータにあったら返す
///無かったらダウンロードして返す
final readImageProvider =
    FutureProvider.family<Uint8List, String>((ref, link) async {
  //Linkをキーにデータを取得する
  final data = await ref.watch(localRepoProvider).readImage(link);
  if (data != null) {
    return data;
  } else {
    //取得できないのならダウンロードして保存する
    if (link.isNotEmpty) {
      final dataImage = await ref.watch(webRepoProvider).fetchHttpByte(link);
      await ref.watch(localRepoProvider).saveImage(link, dataImage);
      return dataImage;
    }
    return Uint8List(0);
  }
});

///cached_network_imageの代替
class CachedNetworkImageView extends ConsumerStatefulWidget {
  final String link;
  double? height;
  double? width;
  BoxFit? fit;
  CachedNetworkImageView({
    super.key,
    required this.link,
    this.height,
    this.width,
    this.fit,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageViewsState();
}

class _ImageViewsState extends ConsumerState<CachedNetworkImageView> {
  @override
  Widget build(BuildContext context) {
    final result = ref.watch(readImageProvider(widget.link));
    return result.when(
      data: (data) {
        return Image.memory(
          data,
          fit: widget.fit ?? BoxFit.fill,
          width: widget.width ?? 150,
          height: widget.height ?? 100,
        );
      },
      error: (error, stackTrace) {
        return Image.asset(
          'assets/empty-box.png',
          fit: widget.fit ?? BoxFit.fill,
          width: widget.width ?? 150,
          height: widget.height ?? 100,
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
