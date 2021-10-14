import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("Need Help ?"),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                '* This is an AI powered Notes app which can be used for everyday note taking',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* You can either use the Mic to input the description or you can type too',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* The priority arranges your notes from high to low order',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* Img2Txt uses deep learning to extract text from images',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* You can upload an image from gallery or take a photo from the camera',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* The extracted text then appears on the notebook. Afterwards a person can copy it too',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* This app has Speech to Text and Text to Speech facilities',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '* A person can click on the speaker icon, so the assistant starts speaking the extracted text',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
        ));
  }
}
