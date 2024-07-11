import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double size;

  const CachedImageWidget({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadImage(url, size),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/default_avatar.png'),
          );
        } else {
          return ClipOval(child: snapshot.data!);
        }
      },
    );
  }

  Future<Widget> _loadImage(String url, double size) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final Uint8List bytes = Uint8List.fromList(response.data);

      if (isSvg(bytes)) {
        final cleanedSvgBytes = cleanSvg(bytes);
        return SvgPicture.memory(
          cleanedSvgBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      } else {
        return ExtendedImage.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/default_avatar.png'),
      );
    }
  }

  bool isSvg(Uint8List bytes) {
    const String svgHeader = '<svg';
    return String.fromCharCodes(bytes).trim().startsWith(svgHeader);
  }

  Uint8List cleanSvg(Uint8List bytes) {
    String svgString = String.fromCharCodes(bytes);
    svgString =
        svgString.replaceAll(RegExp(r'<metadata[^>]*>.*?<\/metadata>'), '');
    return Uint8List.fromList(svgString.codeUnits);
  }
}
