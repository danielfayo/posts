import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:posts/constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, this.onPressed, required this.text, required this.isGoogle});

  final void Function()? onPressed;
  final String text;
  final bool isGoogle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(kPrimary),
        elevation: MaterialStatePropertyAll(0),
        minimumSize: MaterialStatePropertyAll(Size.fromHeight(48)),
        foregroundColor: MaterialStatePropertyAll(kWhite),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      child: isGoogle
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "images/googleLogo.svg",
                  semanticsLabel: "google logo",
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
    );
  }
}
