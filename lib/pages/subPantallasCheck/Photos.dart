import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Photos extends StatefulWidget {
  final String woId;
  final String idUser;
  final String user_type_id;

  const Photos({
    required this.woId,
    required this.idUser,
    required this.user_type_id,
    Key? key,
  }) : super(key: key);

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  String woId = '';
  List<dynamic> jsonResponse = [];
  dynamic selectedEmployedId;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAssignessList(widget.woId);
  }

  Future<void> fetchAssignessList(String woId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/comments/list_get/$woId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty && jsonResponse.length > 1) {
        print(jsonResponse[1]);
      }
      setState(() {});
    }
  }

  List<Widget> buildCommentCards() {
    if (jsonResponse.length < 2) {
      return [];
    }

    List<dynamic> localComments = List.from(jsonResponse[1]);

    return localComments.map<Widget>((comment) {
      final date = comment['date'] as String;
      final name = comment['name'] as String;
      final commentText = comment['comment'] as String;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            title: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 2,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commentText),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
Future<void> saveData() async {
  final url = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/comments/In_post');

  final response = await http.post(url, body: {
    'user_id': '1',
    'wo_id': widget.woId,
    'comment': commentController.text,
  });
  print(response.body);
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body) as bool;
    final message = responseData ? 'Success' : 'Error';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Text('Success!'), // Cambia el mensaje según tus necesidades
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    print('Error to save data. Code: ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.more_vert),
        //   ),
        // ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Work Order Number',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.woId,
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: const Row(
                children: <Widget>[
                  Icon(
                    Icons.photo,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Photos',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
                hintText: 'Write here...',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: buildCommentCards(),
              ),
            ),
          ),
          MaterialButton(
            padding: const EdgeInsets.all(20),
            minWidth: 5,
            height: 50,
            onPressed: saveData,
            color: const Color.fromARGB(255, 39, 17, 243),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
