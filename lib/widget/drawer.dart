import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_app/common/common_process.dart';
import 'package:post_app/enums/page_enum.dart';
import 'package:post_app/providers/user_provider.dart';
import 'package:post_app/widget/create_post.dart';
import 'package:provider/provider.dart';

import 'avatar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late String _avatarSrc;

  @override
  void initState() {
    super.initState();
    _avatarSrc = "https://onl.bz/pkZDTYk";
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;

    return Drawer(
      child: SafeArea(
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
                      createCircleAvatar(_avatarSrc),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: showUserInfo()),
                      )
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: mediaSize.height / 10,
                        child: ElevatedButton.icon(
                            icon: const Icon(Icons.create_rounded),
                            label: const Text("投稿する"),
                            onPressed: () async => await showDialog(
                                context: context,
                                builder: (context) {
                                  return const DialogContentWidget();
                                }))),
                  ),
                ],
              ),
              const Divider(thickness: 1.0, height: 40.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: mediaSize.height / 10,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text("検索する"),
                          onPressed: () {},
                        )),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: mediaSize.height / 16,
                    child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: confirmLogOutWidget(context),
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
      ),
    );
  }

  Widget showUserInfo() {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        String name = provider.user?.name ?? "";
        String postNum =
            NumberFormat("#,##0", 'ja_JP').format(provider.user?.posts);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14.0)),
            Text(
              '$postNum posts',
              style: const TextStyle(fontSize: 12),
            )
          ],
        );
      },
    );
  }

  Widget confirmLogOutWidget(BuildContext context) {
    return AlertDialog(
      elevation: 1.0,
      content: const Text('ログアウトしますか？'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        OutlinedButton(
            onPressed: () => CommonProcess.moveToPage(
                context: context, page: PageEnum.login),
            child: const Text('はい')),
        OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('いいえ'))
      ],
    );
  }
}
