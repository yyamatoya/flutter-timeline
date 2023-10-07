import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post_app/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';

class SendReply with ChangeNotifier {
  bool _isSending = false;
  String? _errorMessage;

  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<void> sendReply() async {
    _isSending = true;
    notifyListeners();
    // API通信
    await Future.delayed(const Duration(seconds: 5), () => throw Error())
        .then((value) => null)
        .catchError((error) {
      _errorMessage = error.toString();
    });
    _isSending = false;
    notifyListeners();
  }
}

class DetailPage extends StatelessWidget {
  final Post post;
  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const String title = "投稿詳細";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final SendReply provider = Provider.of<SendReply>(context);

    return WillPopScope(
      onWillPop: () async => !provider.isSending,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !provider.isSending,
          title: const Text(title),
        ),
        body: Container(
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
                        child: Container(
                          margin: const EdgeInsetsDirectional.only(start: 10.0),
                          child: Text(
                            post.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          DateFormat.Hm().format(post.postedAt),
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
                  },
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(top: 4.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Container(
                        color: Colors.blueGrey.shade50,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                    child: Text(post.description)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
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
                Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Text("${post.name} さんにメッセージを送る"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            TextFormField(
                                enabled: !context.read<SendReply>().isSending),
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                        onPressed: provider.isSending
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();

                                ScaffoldMessengerState state =
                                    ScaffoldMessenger.of(context);

                                // APIに送信処理
                                await provider.sendReply();
                                state.showSnackBar(SnackBar(
                                  content: Text(provider.errorMessage == null
                                      ? '送信が完了しました！'
                                      : '送信に失敗しました。'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: provider.errorMessage != null
                                      ? Colors.red
                                      : null,
                                ));
                              },
                        icon: Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2),
                          child: provider.isSending
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                        ),
                        label: const Text('送信')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
