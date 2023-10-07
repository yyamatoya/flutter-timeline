import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_app/models/post_model.dart';
import 'package:post_app/models/user_model.dart';
import 'package:post_app/pages/detail_page.dart';
import 'package:post_app/pages/draft_page.dart';
import 'package:post_app/pages/login_page.dart';
import 'package:post_app/providers/post_provider.dart';
import 'package:post_app/widget/avatar.dart';
import 'package:provider/provider.dart';

import 'profile_page.dart';

class TimeLinePage extends StatelessWidget {
  final String title = "タイムライン";

  // List<Post> data = <Post>[
  //   Post(1, '山田', 'description', 0.33),
  //   Post(1, '本田', 'これはテストです', 0.33),
  //   Post(1, 'Yuji Yamatoya', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  //   Post(1, 'aaa', 'description', 0.33),
  // ];

  final User _user = User(1, "Yuji Yamatoya", []);

  List<Tab> tabs = const <Tab>[
    Tab(
      text: "新着順",
    ),
    Tab(
      text: "フォロー中",
    )
  ];

  @override
  Widget build(BuildContext context) {
    List<Post> posts = context.watch<PostProvider>().posts;
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
          length: tabs.length,
          child: Builder(
            builder: (context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {}
              });
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                  ],
                  bottom: TabBar(tabs: tabs),
                  titleSpacing: 0.0,
                  title: Text(title),
                  leading: Builder(builder: ((context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  })),
                  centerTitle: true,
                ),
                body: TabBarView(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return createPostWidget(context, posts[index]);
                      },
                      itemCount: posts.length,
                    ),
                  ),
                  const Scaffold()
                ]),
                drawer: Drawer(
                  child: generateDrawer(context, _user),
                ),
                // bottomNavigationBar: BottomNavigationBar(
                //   items: const <BottomNavigationBarItem>[
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.home), label: 'HOME'),
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.face), label: 'MyPage')
                //   ],
                //   currentIndex: 0,
                //   onTap: (value) {},
                //   selectedItemColor: Colors.blue,
                // ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const DraftPage(),
                    //     ));

                    context.read<PostProvider>().addPost(Post(
                        1,
                        DateFormat.Hm().format(DateTime.now()),
                        "a".padRight(140, 'a'),
                        0.33,
                        DateTime.now()));
                  },
                  tooltip: 'add',
                  child: const Icon(Icons.add),
                ),
              );
            },
          )),
    );
  }

  Widget createPostWidget(BuildContext context, Post post) {
    String postedDate = DateFormat.Hm().format(post.postedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  print('Tap on ${post.name} avatar.');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          post: post,
                        ),
                      ));
                },
                child: CircleAvatar(
                  child: Text(post.name),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print('Tap on ${post.name} description');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(post: post),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                post.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              postedDate,
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            post.description,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: const Divider(),
          )
        ],
      ),
    );
  }

  Widget generateDrawer(BuildContext context, User usr) {
    const String src =
        "https://www.lismore.nsw.gov.au/files/assets/public/v/1/1.-households/3.-pets-amp-animals/images/kitten.jpg?dimension=pageimage&w=480";

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    createCircleAvatar(src),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(usr.name),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 14.0)),
                              Text(
                                '${_user.posts.length} posts',
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ],
            ),
            const Divider(),
            const Text('あいうえお'),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                elevation: 1.0,
                                content: const Text('ログアウトしますか？'),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: <Widget>[
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginPage()));
                                      },
                                      child: const Text('はい')),
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('いいえ'))
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('ログアウト')),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
