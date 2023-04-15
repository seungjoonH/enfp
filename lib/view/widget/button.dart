import 'package:flutter/material.dart';

class EButton extends StatelessWidget {
  const EButton({
    Key? key,
    this.text,
    required this.onPressed,
  }) : super(key: key);

  final String? text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text ?? ''),
    );
  }
}
