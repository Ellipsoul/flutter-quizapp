import 'package:flutter/material.dart';

// Generic centered text message
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, this.message = 'Error'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
