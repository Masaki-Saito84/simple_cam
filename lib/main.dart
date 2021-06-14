import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Cam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'cam test app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final picker = ImagePicker();

  Future getImageFromCam() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromLib() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _image == null ?
          Center(
            child: Text('写真がありません')
          )
          :  Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ElevatedButton(
              child: Text('保存する'),
              onPressed: () async {
                if(_image != null) {
                  Uint8List _buffer = await _image!.readAsBytes();
                  final result = await ImageGallerySaver.saveImage(_buffer);
                }
              },
            ),
          ),
          Center(
            child: Image.file(_image!),
          ),
        ]
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            onPressed: getImageFromCam,
            child: Icon(Icons.add_a_photo),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: getImageFromLib,
              child: Icon(Icons.photo_library),
            ),
          )
        ],
      )
    );
  }
}
