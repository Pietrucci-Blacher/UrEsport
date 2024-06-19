import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:extended_image/extended_image.dart';

Future<Widget> buildImageWidget(String url, double size) async {
  try {
    final response = await Dio().get(url,
        options: Options(responseType: ResponseType.bytes));

    final Uint8List bytes = Uint8List.fromList(response.data);

    if (isSvg(bytes)) {
      return SvgPicture.memory(
        bytes,
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
        shape: BoxShape.circle,
      );
    }
  } catch (e) {
    return const Icon(Icons.error);
  }
}

bool isSvg(Uint8List bytes) {
  const String svgHeader = '<svg';
  return String.fromCharCodes(bytes).trim().startsWith(svgHeader);
}
