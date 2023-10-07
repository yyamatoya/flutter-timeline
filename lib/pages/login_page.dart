import 'package:flutter/material.dart';
import '../pages/time_line_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(duration: const Duration(seconds: 1), vsync: this);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formState = GlobalKey<FormState>();

    const String src =
        "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=2000";

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(src),
                  fit: BoxFit.fitHeight,
                  opacity: 0.4)),
          child: Center(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                      child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Icon(Icons.home),
                  )),
                ),
                Form(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'ログインID'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'パスワード'),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        setState(() => _isLoading = true);
                                        // API通信（模擬）
                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                          () {
                                            // throw Error();
                                          },
                                        ).then((value) async {
                                          await Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TimeLinePage()));
                                        }).catchError((error) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: Text('エラーが発生しました'),
                                              );
                                            },
                                          );
                                        });
                                        setState(() => _isLoading = false);
                                      },
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text('ログイン')))),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
