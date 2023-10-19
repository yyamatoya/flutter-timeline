import 'package:flutter/material.dart';

import '../enums/page_enum.dart';
import '../models/post_model.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';

class CommonProcess {
  static Future<void> moveToPage(
      {required BuildContext context,
      required PageEnum page,
      dynamic post}) async {
    Widget Function(BuildContext) builder = (context) => const HomePage();
    if (page == PageEnum.profile) {
      builder = (context) => ProfilePage(post: post as Post);
    }
    if (page == PageEnum.postDetail) {
      builder = (context) => DetailPage(id: post.id as int);
    }
    if (page == PageEnum.login) {
      builder = (context) => const LoginPage();
    }
    Navigator.push(context, MaterialPageRoute(builder: builder));
    return;
  }
}
