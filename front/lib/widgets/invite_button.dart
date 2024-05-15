// invite_button.dart
import 'package:flutter/material.dart';

class InviteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const InviteButton({Key? key, this.onPressed, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
