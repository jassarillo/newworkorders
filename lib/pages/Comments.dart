import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Comments extends StatefulWidget {
  final String woId;
  const Comments({required this.woId, Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String woId = '';
  String priority = '';
  String description = '';
  List<dynamic> jsonResponse = [];

  Color getColorForPriority(String priority) {
    if (priority == 'high') {
      return Colors.red;
    } else if (priority == 'medium') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkOrderDetailsMessages(widget.woId);
  }

  Future<void> fetchWorkOrderDetailsMessages(String woId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Comments_get/$woId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse.length > 1) {
        final woData = jsonResponse[0][0];
        final comments = jsonResponse[1];

        final woId = woData['wo_id'] as String;
        final priority = woData['priority'] as String;
        final description = woData['description'] as String;

        setState(() {
          this.woId = woId;
          this.priority = priority;
          this.description = description;
        });
      }
    }
  }

  List<Widget> buildCommentCards() {
    if (jsonResponse.length < 2) {
      return [];
    }

    final comments = jsonResponse[1];
    return comments.map<Widget>((comment) {
      final descriptionActivity = comment['description_activity'] as String;
      final dueTime = comment['due_time'] as String;
      return Card(
        child: ListTile(
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 2,
            children: <Widget>[
              Text(
                'Texto ',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Link ',
                style: const TextStyle(color: Colors.blue),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  dueTime,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          subtitle: Text(descriptionActivity),
        ),
      );
    }).toList();
  }

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
        child: SingleChildScrollView(
          child: Column(
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
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          this.woId,
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 5),
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 5, 5),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'Priority',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 5, 5),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: getColorForPriority(priority),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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
                      Icons.comment,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'COMMENTS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: buildCommentCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
