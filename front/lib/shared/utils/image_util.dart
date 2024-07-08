import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:extended_image/extended_image.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double size;

  const CachedImageWidget({super.key, required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      cache: true,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(),
            );
          case LoadState.completed:
            return ExtendedImage.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              shape: BoxShape.circle,
              cache: true,
            );
          case LoadState.failed:
            return FutureBuilder<Widget>(
              future: _buildSvgOrDefaultAvatar(url, size),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/default_avatar.png'),
                  );
                } else {
                  return snapshot.data!;
                }
              },
            );
          default:
            return const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/default_avatar.png'),
            );
        }
      },
    );
  }

  Future<Widget> _buildSvgOrDefaultAvatar(String url, double size) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));

      final Uint8List bytes = Uint8List.fromList(response.data);

      if (isSvg(bytes)) {
        return SvgPicture.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        );
      } else {
        return const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/default_avatar.png'),
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
}
