import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String _value;
  const SecondScreen(this._value, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next"),
      ),
      body: Center(
        child: Text(
          "$_value Screen",
          style: TextStyle(fontSize: 32.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.navigate_before, size: 32), label: 'Prev'),
          BottomNavigationBarItem(
              icon: Icon(Icons.android, size: 32), label: '?'),
        ],
        onTap: (value) {
          if (value == 0) {
            Navigator.pop(context);
          }
          if (value == 1) {
            Navigator.pushNamed(context, '/third');
          }
        },
      ),
    );
  }
}
