import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Assigness extends StatefulWidget {
  final String woId;
  const Assigness({required this.woId, Key? key}) : super(key: key);

  @override
  State<Assigness> createState() => _AssignessState();
}

class _AssignessState extends State<Assigness> {
  dynamic selectedWoId;
  String woId = '';
  String priority = '';
  String description = '';
  List<dynamic> jsonResponse = [];
  List<dynamic> filteredWorkOrders = [];
  TextEditingController searchController = TextEditingController();
  //List<dynamic> comments = [];
  Future<void> _refresh() async {
    await fetchWorkOrderDetailsMessages(widget.woId);
  }

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
        'https://srv406820.hstgr.cloud/mainthelpdev/index.php/api/assigness/As_list_get/391/4');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      jsonResponse = json.decode(response.body);
      if (jsonResponse.length > 1) {
        filterWorkOrders(searchController.text);
      }
    }
  }

  List<Widget> buildCommentCards() {
    if (jsonResponse.length < 2) {
      return [];
    }
    List<dynamic> localComments;

    //final comments = jsonResponse[1];
    if (filteredWorkOrders.isNotEmpty) {
      localComments = List.from(filteredWorkOrders);
    } else {
      localComments = List.from(jsonResponse[1]);
    }
    return localComments.map<Widget>((comment) {
      final position = comment['position'] as String;
      final name = comment['name'] as String;
      final woId = comment['name'] as String;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: Radio(
              value: woId,
              groupValue: selectedWoId,
              onChanged: (dynamic value) {
                setState(() {
                  selectedWoId = value;
                });
              },
            ),
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
              ],
            ),
            subtitle: Text(position),
            trailing: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  'https://img.freepik.com/vector-premium/perfil-avatar-mujer-icono-redondo_24640-14047.jpg',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void filterWorkOrders(String query) {
    setState(() {
      filteredWorkOrders = jsonResponse.length >= 2
          ? jsonResponse[1]
              .where((workOrder) =>
                  workOrder['description_activity']
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  workOrder['due_time']
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  workOrder['wo_id']
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList()
          : [];
    });
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
            Navigator.of(context).pop(); // Esta línea permite retroceder
          },
          icon: const Icon(
              Icons.arrow_back), // Cambia el ícono a una flecha hacia atrás
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color:
            Colors.grey.shade200, // Ajusta el tono gris según tus preferencias

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
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        this.woId,
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
                    Icons.person,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Assigness',
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
                controller: searchController,
                onChanged: (value) {
                  filterWorkOrders(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
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
                onPressed: () async {
                  // setState(() {
                  //   problem = problemController.text;
                  // });
                  // /**  ---------  **/
                  // _uploadImageAndSaveOrder();
                  // /**  ---------  **/
                },
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
      ),
    );
  }
}