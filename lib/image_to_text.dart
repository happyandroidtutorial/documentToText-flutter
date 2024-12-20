import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({super.key});

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  XFile? pickedImage;
  String myText = "";
  bool scanning = false;

  final ImagePicker _imagePicker = ImagePicker();

  getImage(ImageSource imageSource) async {
    XFile? result = await _imagePicker.pickImage(source: imageSource);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
      performTextRecognition();
    }
  }

  void performTextRecognition() async {
    setState(() {
      scanning = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedImage!.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final textRecognized = await textRecognizer.processImage(inputImage);

      setState(() {
        myText = textRecognized.text;
        scanning = false;
      });
      textRecognizer.close();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Text Recognition App'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            pickedImage == null
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 350,
                      child: Center(child: Text('No Image Selected')),
                    ),
                  )
                : Center(
                    child: Image.file(
                      File(
                        pickedImage!.path,
                      ),
                      height: 350,
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    icon: Icon(Icons.photo),
                    label: Text('Gallery')),
                ElevatedButton.icon(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('Text Recognized'),
            SizedBox(
              height: 30,
            ),
            scanning
                ? Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 30,
                    )),
                  )
                : AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
                    TypewriterAnimatedText(myText,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(fontSize: 14))
                  ])
          ],
        ));
  }
}
