import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class TextRecog extends StatefulWidget {
  @override
  _TextRecogState createState() => _TextRecogState();
}

class _TextRecogState extends State<TextRecog> {
  File _image;
  String textvalue = "";
  bool isText;
  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    isText = true;
    for (TextBlock block in readText.blocks) {
      setState(() {
        textvalue += block.text;
      });
      print(block.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _image == null
                  ? Container()
                  : Image.file(
                      _image,
                      height: 500,
                      width: 500,
                    ),
              isText == true
                  ? Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF6CA8F1),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(50, 50),
                              spreadRadius: 2.0),
                        ],
                      ),
                      child: SelectableText(
                        "$textvalue",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0, right: 100.0),
              child: FloatingActionButton(
                backgroundColor: Color(0xFF002366),
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                onPressed: () {
                  getImage(true);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 20.0),
              child: FloatingActionButton(
                backgroundColor: Color(0xFF002366),
                child: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                onPressed: () {
                  getImage(true);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: EdgeInsets.only(bottom: 15.0, right: 20.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Color(0xFF002366),
                  label: Text("CONVERT TO TEXT"),
                  onPressed: () {
                    readText();
                  },
                )),
          ),
        ],
      ),
    );
  }
}
