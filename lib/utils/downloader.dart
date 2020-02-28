// import 'package:dio/dio.dart';

// class Download {
//   factory Download() {
//     _this ??= Download._();
//     return _this;
//   }
//   static Download _this;
//   Dio dio = new Dio();
//   Download._();
//   image(serverPath, localPath, filename) async {
//     try {
//       // Saved with this method.
//       var imageId = await dio.download(serverPath, "${localPath}/${filename}",
//           onReceiveProgress: (rec, total) {
//         print(rec);
//       });
//       print(imageId);
//       // if (imageId == null) {
//       //   return;
//       // }

//       // Below is a method of obtaining saved image information.
//       // var fileName = await ImageDownloader.findName(imageId);
//       // var path = await ImageDownloader.findPath(imageId);
//       // var size = await ImageDownloader.findByteSize(imageId);
//       // var mimeType = await ImageDownloader.findMimeType(imageId);
//     } catch (error) {
//       print(error);
//     }
//   }
// }
