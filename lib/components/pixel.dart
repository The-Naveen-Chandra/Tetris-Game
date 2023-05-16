import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Pixel extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var color;
  Pixel({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
