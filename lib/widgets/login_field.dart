import 'package:flutter/material.dart';
import 'package:flutter_api/pallete.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;

  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Pallete.gradient2, width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
