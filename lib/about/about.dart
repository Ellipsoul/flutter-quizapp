import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi',
          // Apply a custom theme, accessing from the parent widget
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
