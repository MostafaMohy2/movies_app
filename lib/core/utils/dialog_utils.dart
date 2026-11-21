import 'package:movies_app/core/utils/build_context_extensions.dart';
import 'package:movies_app/core/utils/number_extensions.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  const DialogUtils();

  Future<void> showAlertDialog(
    BuildContext context, {
    String message = 'Loading',
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              8.horizontalSpace,
              Text(message),
            ],
          ),
        );
      },
    );
  }

  Future<void> showActionDialog(
    BuildContext context, {
    String? message,
    String? title,
    String? postActionTitle,
    Future<void> Function()? postAction,
    Future<void> Function()? negativeAction,
    String? negativeActionTitle,
    bool barrierDismissible = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: message != null ? Text(message) : null,
        actions: [
          if (postActionTitle != null)
            TextButton(
              onPressed: () async {
                context.pop();
                if (postAction != null) {
                  await postAction();
                }
              },
              child: Text(postActionTitle),
            ),
          if (negativeActionTitle != null)
            TextButton(
              onPressed: () async {
                context.pop();
                if (negativeAction != null) {
                  await negativeAction();
                }
              },
              child: Text(negativeActionTitle),
            ),
        ],
      ),
    );
  }
}
