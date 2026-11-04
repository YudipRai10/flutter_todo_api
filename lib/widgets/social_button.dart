import 'package:flutter/material.dart';
import 'package:flutter_api/pallete.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final double horizontalPadding;
  const SocialButton({
    super.key,
    required this.label,
    this.horizontalPadding = 100,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      label: Text(
        label,
        style: const TextStyle(color: Pallete.whiteColor, fontSize: 17),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Pallete.borderColor, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
