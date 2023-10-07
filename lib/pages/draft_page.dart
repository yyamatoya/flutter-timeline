import 'package:flutter/material.dart';
import 'package:post_app/providers/draft_provider.dart';
import 'package:provider/provider.dart';

import '../models/draft_model.dart';

class DraftPage extends StatelessWidget {
  const DraftPage({super.key});
  final String title = "投稿する";
  final bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    Draft? draft = context.watch<DraftProvider>().draft;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () {
                      context.read<DraftProvider>().removeDraft();
                    },
                    child: Text('なかったことにする')),
              ],
            ),
            TextFormField(
              enabled: true,
              obscureText: false,
              cursorColor: Colors.white,
              initialValue: context.watch<DraftProvider>().draft?.subject ?? '',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '自由気ままに書いてみよう',
              ),
              onFieldSubmitted: (value) {
                final Draft d = Draft(value);
                context.read<DraftProvider>().createDraft(d);
              },
            ),
            context.watch<DraftProvider>().isSaved
                ? RichText(
                    text: const TextSpan(children: [
                    WidgetSpan(
                      child: Icon(Icons.check),
                    ),
                    TextSpan(text: "下書きを保存しました！")
                  ]))
                : const Text("")
          ],
        ),
      ),
      // bottomNavigationBar: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     const Divider(),
      //     Container(
      //         margin: EdgeInsets.symmetric(horizontal: 10.0),
      //         child: ElevatedButton(
      //             onPressed: () {
      //               final Draft d = Draft("あいうえお");
      //               context.read<DraftProvider>().createDraft(d);
      //               Navigator.pop(context);
      //             },
      //             child: Text('投稿する'))),
      //   ],
      // ),
    );
  }
}
