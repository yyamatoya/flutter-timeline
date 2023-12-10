import 'package:flutter/material.dart';

class DialogContentWidget extends StatefulWidget {
  const DialogContentWidget({
    super.key,
  });

  @override
  State<DialogContentWidget> createState() => DialogContentWidgetState();
}

class DialogContentWidgetState extends State<DialogContentWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _draftController = TextEditingController();
  final MAX_CONTENT_WIDTH = 120;
  int textLength = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: null,
        body: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 1.1,
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFormField(
                      minLines: 6,
                      maxLines: 6,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.error)),
                      ),
                      controller: _draftController,
                      onChanged: (value) => textLength = value.length,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "内容を入力してください";
                        }
                        if (value.length > MAX_CONTENT_WIDTH) {
                          return "文字数が多すぎます。";
                        }
                        return null;
                      },
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Text("$textLength文字 / $MAX_CONTENT_WIDTH文字")),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("閉じる")),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0)),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                              },
                              child: const Text("送信する")),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
