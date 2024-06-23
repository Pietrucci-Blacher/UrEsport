import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String message;

  const NotificationCard({super.key, required this.imageUrl, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Action to perform on notification block click
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24.0,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}