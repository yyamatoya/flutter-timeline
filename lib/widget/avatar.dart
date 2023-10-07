import 'package:flutter/material.dart';

Widget createCircleAvatar(String url) {
  return CircleAvatar(
      radius: 32,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.fill)),
      ));
}
