import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();

  late Uint8List _imageData = Uint8List(0);
  bool _isLoading = false;

  void _convertTextToImage() async {
    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'https://api.stability.ai/v2beta/stable-image/generate/sd3';
    const apiKey =
        'sk-GQGaiXSdwf7XpHAfllj7DEpbBMwheQg1QNVtnBsEh8YH4FHm'; // Replace with your actual API key

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers.addAll({
        'Authorization': 'Bearer $apiKey',
        'Accept': 'image/*',
      })
      ..fields['prompt'] = _textController.text.isNotEmpty
          ? _textController.text
          : 'Default prompt text'
      ..fields['output_format'] = 'jpeg';

    try {
      final response = await request.send();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        setState(() {
          _imageData = bytes;
        });
      } else {
        final error = await response.stream.bytesToString();
        _showErrorDialog('Failed to generate image: $error');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Convert Text to Image'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  hintText: 'Enter your input',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            //image will show herw
            if (_imageData.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(_imageData)),
                ),
              ),
            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child: TextButton(
                onPressed: _convertTextToImage,
                child: _isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child:
                            CircularProgressIndicator(color: Colors.redAccent),
                      )
                    : const Text(
                        'Generate Image',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
