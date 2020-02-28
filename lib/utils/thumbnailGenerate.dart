import 'dart:io';

import 'dart:io' as Io;

import 'package:acs_lunch/constant/settings.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';


class ThumbnailGenerator {
  static jpgResize({path, destinationPath, width, height}) async {
    String imageName;
    if (path == null) return "Please provide Path";
    if (width == null) return "Please provide Width";
    try {
      Image image = await readJpg(new Io.File(path).readAsBytesSync());
      print("image$image");
      if (destinationPath == null) {
        List pathList = path.split("/");
        imageName = pathList.removeAt(path.split("/").length - 1);
        print("extension ${imageName}");

        destinationPath = await Settings.thumbnailPath + "/";
      }
      print("set ${destinationPath}");
      var x = imageName.split(".");
      // Fill it with a solid color (blue)
      print("width$width");
      Image thumbnail = height != null
          ? copyResize(image, width: width, height: height)
          : copyResize(image, width: width);

      await Io.Directory(destinationPath).create();

      // Save the thumbnail as a PNG.
      new Io.File(destinationPath + x[0] + '.png')
        ..writeAsBytesSync(encodePng(thumbnail));
      return destinationPath + x[0] + '.png';
    } catch (e) {
      return e;
    }
  }
}
