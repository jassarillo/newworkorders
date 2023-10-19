import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:imagepicker/videoPlayer.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key); 

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {




  @override
  void initState() {
    super.initState();
   
  }

//Selecting multiple images from Gallery
  List<XFile>? imageFileList = [];
  void selectImages() async {
  }





  //


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
