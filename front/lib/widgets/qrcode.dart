// Required for getting access to basic Flutter widgets
import 'package:flutter/material.dart';
// QR Flutter package
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  const QRCode({
    super.key,
    this.width,
    this.height,
    required this.data,
  });

  final double? width;
  final double? height;
  final String data;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: 'http://localhost:8080/tournaments/1/invite',
      version: QrVersions.auto,
      size: width ?? 200.0,
    );
  }
}