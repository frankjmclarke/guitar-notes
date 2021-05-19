import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SoundButton extends StatelessWidget {
  final void Function() btn;
  final String name;

  const SoundButton({Key? key, required this.btn, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        child: Text(name),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
        ),
        onPressed: btn,
      ),
    );
  }
}