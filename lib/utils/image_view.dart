import 'dart:io';
import 'package:acs_lunch/constant/settings.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class PhotoViewPage extends StatelessWidget {
  var image;
  var comments;
  bool isFromServer;
  PhotoViewPage({Key key, this.image, this.comments, this.isFromServer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(image);
    print(isFromServer);
    return Scaffold(
        appBar: AppBar(
          title: Text('Image Viewer'),
        ),
        body: new PhotoView(
          imageProvider: isFromServer != null && isFromServer
              ? NetworkImage(Settings.baseUrl + image)
              : FileImage(File(image)),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(comments != null && comments != "" ? comments : "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.body1.fontSize)),
          ),
        )));
  }
}

// _controller.isFromServer
//                                 ? CachedNetworkImage(
//                                     imageUrl: Settings.baseUrl +
//                                         _controller.annotationImagePath,
//                                     placeholder: (context, url) =>
//                                         CircularProgressIndicator(),
//                                     errorWidget: (context, url, error) =>
//                                         Icon(Icons.error),
//                                   )
//                                 : Image.file(_controller.annotationImage),
