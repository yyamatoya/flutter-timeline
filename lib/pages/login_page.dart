import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:post_app/helpers/api_helper.dart';
import 'package:post_app/helpers/local_data_helper.dart';
import 'package:post_app/models/user_model.dart';
import 'package:post_app/providers/user_provider.dart';
import 'package:post_app/widget/alret_dialog.dart';
import 'package:provider/provider.dart';
import '../pages/time_line_page.dart';

Logger logger = Logger(level: Level.all);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final String loginId = 'TQVvHG';
  final String password = '123456';
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  late Future<bool> cache;

  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    cache = checkCache();
    super.initState();
  }

  Future<bool> checkCache() async {
    await LocalDataHelper.setInstance();
    _loginIdController.text = LocalDataHelper.userId ?? "";
    return true;
  }

  Future<void> login(
      BuildContext context, String loginId, String password) async {
    await ApiHelper()
        .login(loginId: loginId, password: password)
        .then((User? usr) {
      if (usr == null) {
        alertDialog(context, null, const Text('ログインに失敗しました'));
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("ログインに成功しました！")));
      // アプリ内部にユーザを読み込む
      context.read<UserProvider>().setUser(usr);
      LocalDataHelper.setUserId = loginId;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TimeLinePage()));
    }).catchError((error) {
      logger.e(error.toString());
      alertDialog(context, null, const Text('エラーが発生しました'));
    });
  }

  Future<void> onPressedLoginButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // ログイン処理
      await login(context, _loginIdController.text, _passwordController.text);
      setState(() => _isLoading = false);
    }
  }

  Widget getLoginFormWidget(BuildContext context) {
    return FutureBuilder(
        future: cache,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Form(
                        key: _formKey,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                  maxLines: 1,
                                  controller: _loginIdController,
                                  keyboardType: TextInputType.visiblePassword,
                                  enabled: !_isLoading,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'ログインID'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "ログインIDが未入力です";
                                    }
                                    return null;
                                  }),
                              TextFormField(
                                  maxLines: 1,
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  enabled: !_isLoading,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'パスワード'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "パスワードが未入力です";
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () async => onPressedLoginButton(),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : const Text('ログイン'))),
                            ],
                          ),
                        )),
                    const Divider(thickness: 1.0),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => {},
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text('新規登録はこちら'))),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const String src =
        "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000";

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.blue.shade50),
          child: Center(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                      child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Icon(Icons.home, size: 40),
                  )),
                ),
                getLoginFormWidget(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
