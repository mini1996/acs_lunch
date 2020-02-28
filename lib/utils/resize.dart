import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart' as material;
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;

class Resize {
  Resize._();
  static resize(image, context) async {
    Directory documentsDirectory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var destinationPath = documentsDirectory.path + "/anotation/resized/";
    await Directory(destinationPath).create(recursive: true);
    var sourcePath = documentsDirectory.path + "/anotation/core/";
    // await Directory(sourcePath).create(recursive: true);
    var size = material.MediaQuery.of(context).size;
    Image image1 = readPng(new Io.File(sourcePath + image).readAsBytesSync());
    // Fill it with a solid color (blue)
    print("sadsadas ${size.width}");
    Image thumbnail = size.width > size.height
        ? copyResize(image1, height: size.height.round() - 70)
        : copyResize(image1, width: size.width.round() - 40);
    //  = copyResize(image1, width: length);

    Io.Directory(destinationPath).create();

    // Save the thumbnail as a PNG.
    return new Io.File(destinationPath + image)
      ..writeAsBytesSync(encodePng(thumbnail));
  }
}
