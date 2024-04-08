import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
      color: kPrimary,
      strokeWidth: 2,
    ),
  );
  }
}