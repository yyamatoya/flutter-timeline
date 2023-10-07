import 'package:flutter/material.dart';

List<BottomNavigationBarItem> commonBottomNavigationItems() {
  return <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 32), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.navigate_next, size: 32), label: 'Next'),
  ];
}
