import 'package:flutter/material.dart';

Future<void> showLoadingDialog(BuildContext context) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: ((context, animation, secondaryAnimation) {
        return WillPopScope(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text(
                    "処理中...",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            onWillPop: () async => false);
      }));
}
