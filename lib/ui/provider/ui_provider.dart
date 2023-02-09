import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//UIのコントローラーなどUIロジックを集める

final searchTextFieldControllerProvider =
    Provider<TextEditingController>((ref) {
  return TextEditingController();
});
