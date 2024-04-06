import 'package:flutter/material.dart';
import 'package:posts/constants/colors.dart';

enum ToastType { success, descructive }

class Toast extends SnackBar {
  Toast({
    super.key,
    required this.toastType,
    required this.toastText,
  }) : super(
          content: Text(
            toastText,
            style: const TextStyle(
              color: kWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor:
              toastType == ToastType.descructive ? kDestructive : kPrimary,
        );

  final ToastType toastType;
  final String toastText;
}