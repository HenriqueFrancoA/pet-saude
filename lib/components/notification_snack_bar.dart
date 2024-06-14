import 'package:flutter/material.dart';

class NotificationSnackbar {
  static void show({
    required BuildContext context,
    required String text,
    Color? backgroundColor,
    TextStyle? textStyle,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(5)),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: textStyle),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Colors.red,
      textStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      text: message,
      backgroundColor: Colors.green,
      textStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}
