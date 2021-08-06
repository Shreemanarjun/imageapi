import 'dart:io';

import 'package:get/get_connect/connect.dart';
import 'package:path/path.dart';

class APIProvider extends GetConnect {
  // Post request
  Future<bool> postAImage(File file) async {
    var isImageUploaded = false;
    final form = FormData({
      'file': MultipartFile(
        file.readAsBytesSync(),
        filename: basename(file.path),
      ),
    });

    var response = await post('https://codelime.in/api/remind-app-token', form);

    if (response.statusCode == 200) {
      if (response.body == "success") {
        //  print("Image uploaded successfully");
        isImageUploaded = true;
      }
    }
    return isImageUploaded;
  }
}
