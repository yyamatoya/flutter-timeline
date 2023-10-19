import 'package:flutter/material.dart';

Future<void> showPostDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return SafeArea(child: const Center(child: DialogContentWidget()));
    },
  );
}

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  controller: _draftController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "内容を入力してください";
                    }
                    return null;
                  },
                ),
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
    );
  }
}
