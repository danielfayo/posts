import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {super.key,
      required this.controller,
      required this.enabled,
      required this.onChanged});

  bool enabled;
  void Function(String)? onChanged;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      enabled: enabled,
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        fillColor: kWhite,
        hintText: "Reply",
        hintStyle: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: kLines),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: kPrimary),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
