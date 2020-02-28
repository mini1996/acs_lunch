import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;



const directoryName = 'DrawPad';

class DrawPad extends StatefulWidget {
  var image;
  DrawPad({Key key, this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrawPadState(image1: this.image);
  }
}

class DrawPadState extends State<DrawPad> {
  // [DrawPadState] responsible for receives drag/touch events by draw/user
  // @_points stores the path drawn which is passed to
  // [DrawPadPainter]#contructor to draw canvas
  List<Offset> _points = <Offset>[];
  var image1;
  DrawPadState({this.image1}) {}
  @override
  void initState() {
    super.initState();
  }

  Future<ui.Image> get rendered async {
    // [CustomPainter] has its own @canvas to pass our
    // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
    // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
    // using @painter[DrawPadPainter] we can call [DrawPadPainter]#paint
    // with the our newly created @canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    // image = await loadImage(new Uint8List.view(data.buffer));
    DrawPadPainter painter = DrawPadPainter(points: _points, image: image1);
    var size = context.size;

    // canvas.drawImage(image, new Offset(0.0, 0.0), new Paint());
    painter.paint(canvas, size);

    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: GestureDetector(
          onDoubleTap: () {},
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox _object = context.findRenderObject();
              Offset top = Offset(0, -150);
              Offset _locationPoints =
                  _object.localToGlobal(details.globalPosition);
              _points = new List.from(_points)..add(_locationPoints + top);
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _points.add(null);
            });
          },
          child: CustomPaint(
            painter: DrawPadPainter(points: _points, image: image1),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

class DrawPadPainter extends CustomPainter {
  // [DrawPadPainter] receives points through constructor
  // @points holds the drawn path in the form (x,y) offset;
  // This class responsible for drawing only
  // It won't receive any drag/touch events by draw/user.
  List<Offset> points = <Offset>[];
  var image;
  DrawPadPainter({this.points, this.image});
  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      // setState(() {});
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    // final ByteData data = await rootBundle.load('lib/assets/unsworth-logo.png');
    // image = await loadImage(new Uint8List.view(data.buffer));

    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;
    if (image != null) {
      canvas.drawImage(image, new Offset(10.0, 0.0), new Paint());
    }
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawPadPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
