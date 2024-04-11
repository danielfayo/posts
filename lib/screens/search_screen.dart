import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/widgets/text_input.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kWhite,
        title: TextInput(
            controller: TextEditingController(),
            enabled: true,
            onChanged: (value) {}),
      ),
    );
  }
}
