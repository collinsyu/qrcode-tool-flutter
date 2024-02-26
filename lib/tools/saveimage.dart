// 保存到相册的UTil
import 'dart:typed_data';
import 'dart:ui';

import 'package:image_gallery_saver/image_gallery_saver.dart';

class SaveToAlbumUtil {
  // static Future<dynamic> saveLocalImage(String imagePath) async {
  //   var image = await ImageUtil.loadImageByFile(imagePath);
  //   ByteData? byteData =
  //   await (image.toByteData(format: ui.ImageByteFormat.png));
  //   if (byteData != null) {
  //     final result =
  //     await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
  //     print("SaveToAlbumUtil result:${result}");
  //     return result;
  //   } else {
  //     throw StateError("saveLocalImage error imagePath:${imagePath}");
  //   }
  // }
  static Future<dynamic> saveToAlbum(Image image) async {
    ByteData? byteData = await (image.toByteData(format: ImageByteFormat.png));
    if (byteData != null) {
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print("SaveToAlbumUtil result:${result}");
      return result;
    } else {
      throw StateError("saveLocalImage error imagePath");
    }
  }

  // static void saveNetworkImage(String imageUrl) async {
  //   var response = await Dio().get(
  //       imageUrl,
  //       options: Options(responseType: ResponseType.bytes));
  //   final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(response.data),
  //       quality: 60,
  //       name: "hello");
  //   print(result);
  // }
}
