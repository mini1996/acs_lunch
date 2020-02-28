import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class PDFCreator {
  GlobalKey _globalKey = new GlobalKey();

  sharePdf(pdf, String fileName) {
    Printing.sharePdf(bytes: pdf.save(), filename: fileName + ".pdf");
  }

  createOrderPDF(vehicleDetails, context, boundary) async {
    final pdf = pdfWidget.Document();

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);

    const imageProvider = const AssetImage("lib/assets/logo.png");
    var imageProviderqR = MemoryImage(pngBytes);
    PdfImage pdfImageQR = await pdfImageFromImageProvider(
        pdf: pdf.document, image: imageProviderqR);

    PdfImage pdfImage = await pdfImageFromImageProvider(
        pdf: pdf.document, image: imageProvider);

    double fontSize = Theme.of(context).textTheme.display1.fontSize;
    pdf.addPage(
      pdfWidget.Page(
        build: (pdfWidget.Context context) {
          return pdfWidget.Container(
            constraints: const pdfWidget.BoxConstraints.expand(),
            child: pdfWidget.Column(children: [
              pdfWidget.Row(
                  mainAxisAlignment: pdfWidget.MainAxisAlignment.spaceAround,
                  children: [
                    pdfWidget.Container(
                      height: 70.0,
                      child: pdfWidget.Image(pdfImage),
                    ),
                    pdfWidget.Container(
                      height: 160.0,
                      child: pdfWidget.Image(pdfImageQR),
                    ),
                  ]),
              pdfWidget.Container(
                padding: pdfWidget.EdgeInsets.only(top: 20.0),
                child: pdfWidget.Column(
                  children: [
                    pdfWidget.Row(
                      children: [
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  "Registration",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  (vehicleDetails.registrationNumber != "" &&
                                          vehicleDetails.registrationNumber !=
                                              null)
                                      ? vehicleDetails.registrationNumber
                                      : "",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                      ],
                    ),
                    pdfWidget.Row(
                      children: [
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  "Destination",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  (vehicleDetails.destinationName != "" &&
                                          vehicleDetails.destinationName !=
                                              null)
                                      ? vehicleDetails.destinationName
                                      : "",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                      ],
                    ),
                    pdfWidget.Row(
                      children: [
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  "Sreference",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  (vehicleDetails.esl != "" &&
                                          vehicleDetails.esl != null)
                                      ? vehicleDetails.esl
                                      : "",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                      ],
                    ),
                    // pdfWidget.Row(
                    //   children: [
                    //     pdfWidget.Expanded(
                    //         child: pdfWidget.Padding(
                    //             padding: pdfWidget.EdgeInsets.symmetric(
                    //                 vertical: 10.0),
                    //             child: pdfWidget.Text(
                    //               "Date",
                    //               style: pdfWidget.TextStyle(
                    //                   fontSize: fontSize,
                    //                   fontWeight: pdfWidget.FontWeight.bold),
                    //             ))),
                    //     pdfWidget.Expanded(
                    //         child: pdfWidget.Padding(
                    //             padding: pdfWidget.EdgeInsets.symmetric(
                    //                 vertical: 10.0),
                    //             child: pdfWidget.Text(
                    //               "17/09/2019",
                    //               style: pdfWidget.TextStyle(
                    //                   fontSize: fontSize,
                    //                   fontWeight: pdfWidget.FontWeight.bold),
                    //             ))),
                    //   ],
                    // ),
                    // pdfWidget.Row(
                    //   children: [
                    //     pdfWidget.Expanded(
                    //         child: pdfWidget.Padding(
                    //             padding: pdfWidget.EdgeInsets.symmetric(
                    //                 vertical: 10.0),
                    //             child: pdfWidget.Text(
                    //               "Client",
                    //               style: pdfWidget.TextStyle(
                    //                   fontSize: fontSize,
                    //                   fontWeight: pdfWidget.FontWeight.bold),
                    //             ))),
                    //     pdfWidget.Expanded(
                    //         child: pdfWidget.Padding(
                    //             padding: pdfWidget.EdgeInsets.symmetric(
                    //                 vertical: 10.0),
                    //             child: pdfWidget.Text(
                    //               "",
                    //               style: pdfWidget.TextStyle(
                    //                   fontSize: fontSize,
                    //                   fontWeight: pdfWidget.FontWeight.bold),
                    //             ))),
                    //   ],
                    // ),
                    pdfWidget.Row(
                      children: [
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  "VIN",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  (vehicleDetails.vin != "" &&
                                          vehicleDetails.vin != null)
                                      ? vehicleDetails.vin
                                      : "",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                      ],
                    ),
                    pdfWidget.Row(
                      children: [
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  "Packing Method",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                        pdfWidget.Expanded(
                            child: pdfWidget.Padding(
                                padding: pdfWidget.EdgeInsets.symmetric(
                                    vertical: 10.0),
                                child: pdfWidget.Text(
                                  (vehicleDetails.packingMethod != "" &&
                                          vehicleDetails.packingMethod != null)
                                      ? vehicleDetails.packingMethod
                                      : "",
                                  style: pdfWidget.TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: pdfWidget.FontWeight.bold),
                                ))),
                      ],
                    ),
                  ],
                ),
              )
            ]),
          );
        },
      ),
    );

    return pdf;
  }
}
