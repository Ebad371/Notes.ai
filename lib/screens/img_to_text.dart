import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Img2Text extends StatefulWidget {
  @override
  _Img2TextState createState() => _Img2TextState();
}

class _Img2TextState extends State<Img2Text> {
  Future<File> imageFile;
  File _image;
  String result = '';
  TextDetector textDetector;
  ImagePicker imagePicker;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  void initState() {
    super.initState();
    initializeTts();
    imagePicker = ImagePicker();
    textDetector = GoogleMlKit.vision.textDetector();
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future _speak() async {
    flutterTts.setSpeechRate(0.6);
    flutterTts.speak(result);
  }

  void _stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  doTextRecognition() async {
    final inputImage = InputImage.fromFile(_image);
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    setState(() {
      result = text;
    });
    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterTts.stop();
  }

  Future<void> chooseImageFromCamera() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);

    _image = File(pickedFile.path);
    setState(() {});
    doTextRecognition();
  }

  Future<void> chooseImageFromGallery() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    _image = File(pickedFile.path);
    setState(() {});
    doTextRecognition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 40,
            height: 40,
            child: Material(
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Icon(
                  Icons.copy,
                ),
                onPressed: () async {
                  await FlutterClipboard.copy(result);
                  _showSnackBar(context, 'Content Copied...');
                },
                heroTag: null,
                backgroundColor: Colors.red[900],
              ),
            ),
          ),
          Container(
            width: 70,
            height: 70,
            child: AvatarGlow(
              animate: isSpeaking,
              glowColor: Colors.red[900],
              endRadius: 50.0,
              repeat: true,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 50),
              child: Material(
                // Replace this child with your own
                elevation: 28.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: IconButton(
                    icon: Icon(isSpeaking
                        ? Icons.volume_up_outlined
                        : Icons.volume_down_outlined),
                    color: Colors.red[900],
                    onPressed: () {
                      _speak();
                    },
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Container(
            width: 40,
            height: 40,
            child: Material(
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Icon(
                  Icons.volume_off_outlined,
                ),
                onPressed: () {
                  _stop();
                },
                heroTag: null,
                backgroundColor: Colors.red[900],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 40,
            height: 40,
            child: Material(
              color: Colors.grey[100],
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Container(
                  width: 140,
                  height: 150,
                  child: Icon(
                    Icons.image,
                    color: Colors.red[900],
                    size: 25.0,
                  ),
                ),
                onPressed: () {
                  chooseImageFromGallery();
                },
                heroTag: null,
                backgroundColor: Colors.grey[100],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 40,
            height: 40,
            child: Material(
              elevation: 28.0,
              shape: CircleBorder(),
              child: FloatingActionButton(
                child: Container(
                  width: 140,
                  height: 150,
                  child: Icon(
                    Icons.camera,
                    color: Colors.grey[100],
                    size: 25.0,
                  ),
                ),
                onPressed: () {
                  chooseImageFromCamera();
                },
                heroTag: null,
                backgroundColor: Colors.red[900],
              ),
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.help,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context)
      //             .push(MaterialPageRoute(builder: (context) => NewScreen()));
      //       },
      //     )
      //   ],
      // ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              width: 100,
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/notebook.png'),
                    fit: BoxFit.cover),
              ),
              height: 200,
              width: 200,
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                  child: Text(
                '$result',
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'solway', fontSize: 10),
              )),
            ),

            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, right: 140),
                  child: Stack(children: <Widget>[
                    Stack(children: <Widget>[
                      Center(
                        child: Image.asset(
                          'images/clipboard.png',
                          height: 240,
                          width: 240,
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        Center(
                          child: FlatButton(
                            onPressed: chooseImageFromCamera,
                            onLongPress: chooseImageFromGallery,
                            child: Container(
                              margin: EdgeInsets.only(top: 25),
                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      width: 140,
                                      height: 192,
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      width: 140,
                                      height: 150,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
            // Container(margin:EdgeInsets.only(top:300,right: 80),child: Center(
            //
            // )),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
