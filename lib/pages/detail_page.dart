import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_app/pages/profile_page.dart';

import '../models/post_model.dart';

class DetailPage extends StatelessWidget {
  final Post post;
  const DetailPage({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    const String title = "投稿詳細";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                post: post,
                              ),
                            )),
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          DateFormat.Hm().format(DateTime.now()),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          content: const Text('通報しますか？'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'はい',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'いいえ',
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ],
                        );
                      },
                    );
                    // showAboutDialog(context: context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Container(
                      color: Colors.blueGrey.shade50,
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(post.description),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                  child: IconButton(
                                icon: const Icon(Icons.thumb_up),
                                splashRadius: 20,
                                iconSize: 20,
                                onPressed: () {},
                              )),
                            ])),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            WidgetSpan(
                                child: IconButton(
                              icon: const Icon(Icons.thumb_down),
                              splashRadius: 20,
                              iconSize: 20,
                              onPressed: () {},
                            )),
                          ])),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("${post.name} さんに返信する"),
                  Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: TextFormField(
                            enabled: true,
                          ),
                        ),
                        OutlinedButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            )),
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
