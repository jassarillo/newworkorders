import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class OperativeCost extends StatefulWidget {
  final String woId;
  final String idUser;
  final String user_type_id;
  const OperativeCost({
    required this.woId,
    required this.idUser,
    required this.user_type_id,
    Key? key,
  }) : super(key: key);

  @override
  State<OperativeCost> createState() => _OperativeCostState();
}

class _OperativeCostState extends State<OperativeCost> {
  dynamic selectedWoId;
  List<dynamic> jsonResponse = [];
  List<dynamic> filteredWorkOrders = [];
  String description = '';
  String cost = '';
  String filePath = '';
  String selectedFileName = '';
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  Future<void> _refresh() async {
    await fetchOperativeCostList(widget.woId);
  }

  @override
  void initState() {
    super.initState();
    fetchOperativeCostList(widget.woId);
  }

  Future<void> pickFile() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
    }

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          filePath = result.files.single.path!;
          selectedFileName = result.files.single.name ?? '';
        });
      }
    } else {
      print('Permiso denegado para acceder al almacenamiento.');
    }
  }

  Future<void> fetchOperativeCostList(String woId) async {
    final url = Uri.parse(
        //'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/operativecost/List_get/$woId');
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/operativecost/List_get/$woId');
    final response = await http.get(url);
    //print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(response.body);
      });
    }
  }

  List<Widget> buildOpCostCards() {
    if (jsonResponse == null ||
        jsonResponse.isEmpty ||
        jsonResponse[0] == null) {
      return [];
    }
    List<dynamic> localOpCosts;

    if (filteredWorkOrders.isNotEmpty) {
      localOpCosts = List.from(filteredWorkOrders);
    } else {
      localOpCosts = List.from(jsonResponse[0]);
    }

    return localOpCosts.map<Widget>((opCost) {
      final operationCostId = opCost['operation_cost_id'].toString();
      final description = opCost['description'] as String?;
      final url_file = opCost['url'] as String?;

      //print('Description: $description, URL: $url_file');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        child: GestureDetector(
          onTap: () async {
            if (description != null && url_file != null) {
              // Verifica que description y url_file no sean nulos antes de abrir la URL
              await launchUrl(Uri.parse(
                  'http://srv406820.hstgr.cloud/mainthelpdev/' + url_file));
            }
          },
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
                    description ?? 'No description available',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              subtitle:
                  Text("Date: ${opCost['date']} | Cost: ${opCost['cost']}"),
              trailing: url_file != null && url_file.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (description != null && url_file != null) {
                          await launchUrl(Uri.parse(
                              'http://srv406820.hstgr.cloud/mainthelpdev/' +
                                  url_file));
                        }
                      },
                      child: Icon(
                        Icons.description,
                        color: Colors.blue,
                      ),
                    )
                  : Icon(
                      Icons.description,
                      color: Colors
                          .grey, // Cambia el color a gris si la URL es nula o vacía
                    ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> saveData() async {

    final url = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/operativecost/In_post',
    );
    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = widget.idUser
      ..fields['wo_id'] = widget.woId
      ..fields['description'] = descriptionController.text
      ..fields['cost'] = costController.text
      ..files.add(
        await http.MultipartFile.fromPath(
          'pdf',
          filePath,
        ),
      );
    //print(request);
    var streamedResponse = await request.send();

    // Obtén la respuesta completa utilizando http.Response.fromStream
    var response = await http.Response.fromStream(streamedResponse);

    //print(response.body);
    if (response.statusCode == 200) {
           // Analiza el cuerpo de la respuesta JSON
      final responseData = json.decode(response.body);
      final tipo = responseData['tipo'] as int?;
      final message = responseData['msn'] as String?;

      if (tipo != null && tipo == 1 && message != null) {
        // Muestra un AlertDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Respuesta inesperada: $responseData');
      }
    } else {
      print('Error al guardar los datos. Código: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
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
          icon: const Icon(
            Icons.arrow_back,
          ),
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
        color: Colors.grey.shade200,
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
                    Icons.person,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Operative Cost',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: costController,
                  decoration: InputDecoration(
                    labelText: 'Cost',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: ElevatedButton(
            //     onPressed: pickFile,
            //     child: Text('Select File'),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity, // Ocupa todo el ancho disponible
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: pickFile,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(3.0),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(10.0),
                    ),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_upload,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Select File',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              'Selected File: $selectedFileName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buildOpCostCards(),
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
      ),
    );
  }
}
