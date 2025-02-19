// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatelessWidget {
  final String path;

  const PDFScreen(this.path, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PDF Preview',
          style: TextStyle(
            color: Colors.white,
<<<<<<< HEAD
<<<<<<< HEAD
            
=======
            fontFamily: 'Titillium Web',
>>>>>>> d161894 (Documents Are Pulling Properly)
=======
            
>>>>>>> a440029 (Removed All Font Issues)
          ),
        ),
      ),
      body: PDFView(
        filePath: path,
      ),
    );
}