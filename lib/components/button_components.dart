import 'package:flutter/material.dart';

class CustomButton extends MaterialButton {
  CustomButton({
    Key? key,
    required VoidCallback onPressed,
    String? text,
    Color? color,
    Color? textColor,
    double? fontSize,
    double? borderRadius,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: Text(
            text ?? '',
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? 16,
            ),
          ),
          color: color ?? const Color.fromARGB(255, 82, 82, 82),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        );
}
