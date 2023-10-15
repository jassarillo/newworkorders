import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:imagepicker/videoPlayer.dart';

class SelectImages extends StatefulWidget {
  const SelectImages({Key? key}) : super(key: key);

  @override
  State<SelectImages> createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectImages> {
  var _image;
  var _video;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

//Selecting multiple images from Gallery
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  void pickImageFromGallery() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });
  }

  void pickImageFromCamera() async {
    XFile image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  // void pickVideoFromGallery() async {
  //   XFile _video = await imagePicker.pickVideo(source: ImageSource.gallery);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (builder) => VideoPlayerFromFile(
  //         videopath: _video.path,
  //       ),
  //     ),
  //   );
  // }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                pickImageFromGallery();
              },
              child: Text('FROM GALLERY'),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                pickImageFromCamera();
              },
              child: Text('FROM CAMERA'),
            ),
            // MaterialButton(
            //   color: Colors.blue,
            //   onPressed: () {
            //     pickVideoFromGallery();
            //   },
            //   child: Text("Select video from Gallery"),
            // ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                selectImages();
              },
              child: Text('Select Multiple Images'),
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: _image != null
                  ? Image.file(
                      _image,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Text("Pick an image from gallery or click"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: imageFileList!.length,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList![index].path),
                        height: 200,
                        width: 200,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
