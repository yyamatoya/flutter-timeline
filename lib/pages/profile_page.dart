import 'package:flutter/material.dart';
import 'package:post_app/models/user_model.dart';
import 'package:post_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';

class ProfilePage extends StatelessWidget {
  final Post post;
  const ProfilePage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    String src = "https://wallpapercave.com/dwp1x/wp2552717.jpg";
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 6,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(src), fit: BoxFit.cover))),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => {},
                      child: CircleAvatar(
                        radius: 24,
                        child: Text(post.name),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        post.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
