import 'package:flutter/material.dart';

Future<dynamic> alertDialog(
    BuildContext context, Widget? title, Widget? content) {
  return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text('エラーが発生しました'),
        );
      });
}
