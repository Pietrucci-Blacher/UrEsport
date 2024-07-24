import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:xml/xml.dart' as xml;

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double size;
  final bool isNeutral;

  const CachedImageWidget(
      {super.key,
      required this.url,
      required this.size,
      this.isNeutral = false});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return FutureBuilder<bool>(
      future: _isSvg(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          if (!isNeutral) {
            return const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/default_avatar.png'),
            );
          } else {
            return CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
            );
          }
        } else if (snapshot.data!) {
          return FutureBuilder<String>(
            future: _cleanSvg(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Text(l.svgLoadError);
              } else {
                return SvgPicture.string(
                  snapshot.data!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                );
              }
            },
          );
        } else {
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
                  return ClipOval(
                    child: Image.network(
                      url,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  );
                case LoadState.failed:
                  if (!isNeutral) {
                    return const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/default_avatar.png'),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                    );
                  }
                default:
                  if (!isNeutral) {
                    return const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/default_avatar.png'),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                    );
                  }
              }
            },
          );
        }
      },
    );
  }

  Future<bool> _isSvg(String url) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final Uint8List bytes = Uint8List.fromList(response.data);
      return isSvg(bytes);
    } catch (e) {
      return false;
    }
  }

  bool isSvg(Uint8List bytes) {
    const String svgHeader = '<svg';
    return String.fromCharCodes(bytes).trim().startsWith(svgHeader);
  }

  Future<String> _cleanSvg(String url) async {
    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final document = xml.XmlDocument.parse(String.fromCharCodes(response.data));
    document.findAllElements('metadata').forEach((element) => element.remove());
    return document.toXmlString(pretty: true);
  }
}
