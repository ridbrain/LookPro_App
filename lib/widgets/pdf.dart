import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PDFPages extends StatelessWidget {
  PDFPages({
    required this.title,
    required this.pdfUrl,
  });

  final String title;
  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(title),
      ),
      body: FutureBuilder(
        future: PDFDocument.fromURL(pdfUrl),
        builder: (context, AsyncSnapshot<PDFDocument?> builder) {
          if (builder.hasData) {
            return PDFViewer(
              document: builder.data!,
              showPicker: false,
              showNavigation: false,
              scrollDirection: Axis.horizontal,
              zoomSteps: 1,
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
