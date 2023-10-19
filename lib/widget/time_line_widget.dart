import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:post_app/enums/page_enum.dart';
import 'package:post_app/pages/home_page.dart';

import '../helpers/api_helper.dart';
import '../models/post_model.dart';
import '../pages/detail_page.dart';
import '../pages/profile_page.dart';
import '../common/common_process.dart';

class TimeLineWidget extends StatefulWidget {
  const TimeLineWidget({super.key});

  @override
  State<TimeLineWidget> createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  var logger = Logger();

  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updatePosts() async {
    setState(() {
      posts = fetchPost();
    });
  }

  // 投稿データを取得する
  Future<List<Post>> fetchPost() async {
    List<Post> posts = await ApiHelper().getPosts();
    return posts;
  }

  Widget errorWidget({String message = "", Function()? onPressed}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(message)),
          FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.replay_outlined),
              label: const Text('再読込'))
        ],
      ),
    );
  }

  Widget getAvatarIcon(Post post) {
    return CircleAvatar(
      child: Text(post.name),
    );
  }

  Widget getNiceInfo(Post post) {
    return Container(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(children: [
          WidgetSpan(
              child: Icon(
            Icons.thumb_up,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          )),
          const WidgetSpan(
              child: SizedBox(
            width: 8,
          )),
          TextSpan(
            text: NumberFormat("#,##0", 'ja_JP').format(post.nices),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ]),
      ),
    );
  }

  Widget createPostWidget(BuildContext context, Post post) {
    String postedDate = DateFormat.Hm().format(post.createdAt);
    Size mediaSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              // 顔アイコン
              InkWell(
                  onTap: () => CommonProcess.moveToPage(
                      context: context, page: PageEnum.profile, post: post),
                  child: getAvatarIcon(post)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
              Expanded(
                child: InkWell(
                  onTap: () => CommonProcess.moveToPage(
                      context: context, page: PageEnum.postDetail, post: post),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // 名前
                          Text(
                            post.name,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black45),
                          ),
                          // 日付
                          Text(
                            postedDate,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        ],
                      ),
                      // 投稿内容
                      SizedBox(
                        height: mediaSize.height / 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Text(
                                post.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            // いいね数
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                getNiceInfo(post),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          updatePosts();
        },
        child: FutureBuilder(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return snapshot.hasError
                  ? errorWidget(message: "エラーが発生しました", onPressed: updatePosts)
                  : errorWidget(message: "データがありません", onPressed: updatePosts);
            }
            return snapshot.data!.isEmpty
                ? errorWidget(
                    message: "誰も投稿していないようです…",
                    onPressed: updatePosts,
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, i) =>
                        createPostWidget(ctx, snapshot.data![i]),
                    itemCount: snapshot.data!.length,
                  );
          },
        ));
  }
}
