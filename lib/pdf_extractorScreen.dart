import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

class PDFTextExtractorPage extends StatefulWidget {
  @override
  _PDFTextExtractorPageState createState() => _PDFTextExtractorPageState();
}

class _PDFTextExtractorPageState extends State<PDFTextExtractorPage> {
  String extractedText = " Extracted text will show here";

  Future<void> pickAndExtractText() async {
    try {
      // Step 1: Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Allow only PDF files
      );

      if (result != null) {
        final filePath = result.files.single.path;

        if (filePath != null) {
          // Step 2: Load the PDF file
          final fileBytes = File(filePath).readAsBytesSync();
          PdfDocument pdfDocument = PdfDocument(inputBytes: fileBytes);

          // Step 3: Extract text from all pages
          String text = PdfTextExtractor(pdfDocument).extractText();

          // Step 4: Update the UI
          setState(() {
            extractedText = text.isNotEmpty ? text : "No text found in the PDF.";
          });

          // Dispose the document to release resources
          pdfDocument.dispose();
        }
      }
    } catch (e) {
      setState(() {
        extractedText = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF To Text'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueAccent
              ),
              child: TextButton(
                onPressed: pickAndExtractText,
                child: Text('Pick PDF and Extract Text',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                   margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200]
              ),
                  child: Text(
                    extractedText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
