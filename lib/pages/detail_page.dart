import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:post_app/common/common_process.dart';
import 'package:post_app/enums/page_enum.dart';
import 'package:provider/provider.dart';

import '../helpers/api_helper.dart';
import '../pages/profile_page.dart';
import '../providers/user_provider.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class ReplyProvider with ChangeNotifier {
  bool _isSending = false;
  String? _errorMessage;

  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<void> sendReply(Post post, User usr, String reply) async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await ApiHelper().postReply(post, usr, reply);
    } catch (error) {
      print(error.toString());
    }
    _isSending = false;
    notifyListeners();
  }
}

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final String title = "投稿詳細";
  late Future<Post> post;

  @override
  void initState() {
    super.initState();
    getDetailPost();
  }

  void getDetailPost() async {
    setState(() {
      post = Future(() => Post(
          id: 1,
          name: '適当太郎',
          description: '適当に書いてみた',
          nices: 10,
          replies: [],
          createdAt: DateTime.now()));

      // post = ApiHelper().getDetailPost(widget.id);
    });
  }

  void pushNice(Post post) async {
    Logger().d("pushed Nice id=${post.id}");
    int? nices = await ApiHelper().pushNice(post);

    Logger().d("pushed Nice @$nices");
    setState(() {
      if (nices != null) {
        post.nices = nices;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSendReply(
    BuildContext context,
    Post post,
  ) async {
    final User? usr = context.read<UserProvider>().user;

    FocusScope.of(context).unfocus();
    ScaffoldMessengerState state = ScaffoldMessenger.of(context);
    String? errorMessage = context.read<ReplyProvider>().errorMessage;
    // APIに送信処理
    await context.read<ReplyProvider>().sendReply(
          post,
          usr!,
          "test",
        );
    String responseMessage = errorMessage == null ? "送信が完了しました！" : "送信に失敗しました。";

    state.showSnackBar(SnackBar(
      content: Text(responseMessage),
      duration: const Duration(seconds: 2),
      backgroundColor: errorMessage != null ? Colors.red : null,
    ));
  }

  Widget sendReplyWidget(Post post, bool isLoading) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    TextFormField(enabled: !isLoading),
                  ],
                ),
              ),
            ),
            OutlinedButton.icon(
                onPressed:
                    !isLoading ? null : () async => onSendReply(context, post),
                icon: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
                ),
                label: const Text('送信')),
          ],
        )
      ],
    );
  }

  Future<dynamic> showReportDialog() {
    return showDialog(
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
  }

  @override
  Widget build(BuildContext context) {
    bool isSending = context.watch<ReplyProvider>().isSending;
    return WillPopScope(
      onWillPop: () async => !isSending,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isSending,
          title: Text(title),
        ),
        body: FutureBuilder(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return snapshot.hasData
                ? Container(
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
                                  onTap: () => CommonProcess.moveToPage(
                                      context: context,
                                      page: PageEnum.profile,
                                      post: snapshot.data!),
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Center(
                                        child: Text(snapshot.data!.name[0])),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsetsDirectional.only(
                                        start: 10.0),
                                    child: Text(
                                      snapshot.data!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    DateFormat.Hm()
                                        .format(snapshot.data!.createdAt),
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () async => await showReportDialog(),
                            child: Container(
                              margin:
                                  const EdgeInsetsDirectional.only(top: 4.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                                child: Container(
                                  color: Colors.blueGrey.shade50,
                                  child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: SingleChildScrollView(
                                              child: Text(
                                                  snapshot.data!.description)),
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
                            child: Container(
                              margin: const EdgeInsets.all(2.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () => pushNice(snapshot.data!),
                                      icon: const Icon(Icons.thumb_up)),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0)),
                                  Text("${snapshot.data!.nices}"),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          sendReplyWidget(snapshot.data!, isSending),
                        ],
                      ),
                    ),
                  )
                : Text(snapshot.error.toString());
          },
        ),
      ),
    );
  }
}
