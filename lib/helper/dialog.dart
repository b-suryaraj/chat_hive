import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.deepPurple.withOpacity(.7),
        behavior: SnackBarBehavior.floating));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.withOpacity(.9)),
          backgroundColor: Colors.white, 
          semanticsLabel: 'Loading...', 
          semanticsValue: 'Loading', 
        ),
      ),
    );
  }

}