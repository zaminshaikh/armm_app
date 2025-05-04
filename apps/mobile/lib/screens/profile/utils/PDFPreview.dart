// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';

class PDFScreen extends StatelessWidget {
  final String path;

  const PDFScreen(this.path, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'PDF Preview',
          style: GoogleFonts.inter(
            color: Colors.white,
          ),
        ),
      ),
      body: PDFView(
        filePath: path,
      ),
    );
}