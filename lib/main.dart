import 'package:flutter/material.dart';
import 'package:post_app/pages/time_line_page.dart';
import 'package:post_app/providers/draft_provider.dart';
import 'package:post_app/providers/post_provider.dart';
import 'package:post_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/second_screen.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PostProvider()),
      ChangeNotifierProvider(create: (_) => DraftProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: "Noto Sans JP"),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/third': (context) => SecondScreen('Third')
      },
    );
  }
}
