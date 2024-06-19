import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const CustomToast({
    super.key,
    required this.message,
    required this.onClose,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.0,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 14.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: onClose,
                iconSize: 16.0,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}