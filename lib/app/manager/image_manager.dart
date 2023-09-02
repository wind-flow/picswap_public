import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageManager {
  static Future<File?> pickImage(ImageSource imageSource) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: imageSource);

      final imgFile = File(image!.path); // 가져온 이미지를 _image에 저장

      File? compressedFile = await FlutterImageCompress.compressAndGetFile(
        imgFile.path,
        '${dirname(imgFile.path)}/${imgFile.path.split('/').last}_tmp.jpg',
        quality: 50,
        minWidth: 800,
        minHeight: 600,
      );

      return compressedFile;
    } catch (e) {
      throw Exception(e);
    }
  }
}
