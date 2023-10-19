import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String pageTitle = "Home";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            child: const Text(
              'Home Screen',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
          ),
        )
    );
  }
}
