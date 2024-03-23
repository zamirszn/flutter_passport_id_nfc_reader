import 'package:flutter/services.dart';

const imageChannel = MethodChannel('image_channel');

Future<Uint8List?> decodeImage(Uint8List jp2ImageData, context) async {
  Uint8List? decodedImageData;

  try {
    final result = await imageChannel
        .invokeMethod('decodeImage', {'jp2ImageData': jp2ImageData});
    decodedImageData = Uint8List.fromList(result);
  } catch (e) {
    decodedImageData =null;
  }

  return decodedImageData;
}
