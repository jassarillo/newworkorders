import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TroubleShooting extends StatefulWidget {
  final String insertId;
  final String idUser;
  const TroubleShooting(
      {required this.insertId, required this.idUser, Key? key})
      : super(key: key);

  @override
  State<TroubleShooting> createState() => _TroubleShootingState();
}

class WorkOrderUnit {
  final String title_id;
  final String title_description;

  WorkOrderUnit({required this.title_id, required this.title_description});

  factory WorkOrderUnit.fromJson(Map<String, dynamic> json) {
    return WorkOrderUnit(
      title_id: json['title_id'],
      title_description: json['title_description'],
    );
  }
}

class WorkOrderAsset {
  final String woUitId;
  final String AssetName;

  WorkOrderAsset({required this.woUitId, required this.AssetName});

  factory WorkOrderAsset.fromJson(Map<String, dynamic> json) {
    return WorkOrderAsset(
      woUitId: json['id_asset'],
      AssetName: json['asset_name'],
    );
  }
}

class WorkOrderPriority {
  final String priorityId;
  final String priority;

  WorkOrderPriority({required this.priorityId, required this.priority});

  factory WorkOrderPriority.fromJson(Map<String, dynamic> json) {
    return WorkOrderPriority(
      priorityId: json['priority_id'],
      priority: json['priority'],
    );
  }
}

class _TroubleShootingState extends State<TroubleShooting> {
  List<WorkOrderUnit> workOrderUnitList = [];
  List<WorkOrderPriority> workOrderPriorityList = [];
  List<WorkOrderAsset> workOrderAssetList = [];
  List<Map<String, String>> jsonResponseCheck = [];

  WorkOrderUnit? selectedStatus;
  WorkOrderAsset? selectedAsset;
  WorkOrderPriority? selectedPriority;

  @override
  void initState() {
    super.initState();
    fetchWorkOrderUnitList();
  }

  Future<void> fetchWorkOrderUnitList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/Cat_list_get/408'), //Primer select
    );

    print("==>>>>" + response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderUnit> statuses = (data.isNotEmpty && data is List)
          ? data.map((e) => WorkOrderUnit.fromJson(e)).toList()
          : [];

      setState(() {
        workOrderUnitList = statuses;
      });

      print('Work Order Units:');
      workOrderUnitList.forEach((element) {
        print('${element.title_id}: ${element.title_description}');
      });
    } else {
      throw Exception('Failed to load work order data');
    }
  }

  Future<void> fetchWorkOrderAssetList(String siteId) async {
    final response = await http.post(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Unit_asset_post'),
      body: {
        "site_id": siteId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderAsset> assets =
          data.map((e) => WorkOrderAsset.fromJson(e)).toList();

      setState(() {
        workOrderAssetList = assets;
      });
    } else {
      throw Exception('Failed to load work order assets');
    }
  }

  Future<void> fetchtroubleShooting(String insertId, String titleId) async {
    final postUrl = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/List_questions_post');//preguntas de los checks

    final response = await http.post(
      postUrl,
      body: {
        'tbs_title': titleId,
        'wo_id': insertId,
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final dynamic decodedResponse = json.decode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('getQuestions')) {
        setState(() {
          jsonResponseCheck = List<Map<String, String>>.from(
            decodedResponse['getQuestions'].map<Map<String, String>>(
              (question) => Map<String, String>.from(question),
            ),
          );
        });
      }
    } else {
      // Handle the request error if necessary.
    }
  }

  List<Widget> buildCheckboxList() {
    return jsonResponseCheck.map<Widget>((question) {
      final tbsId = question['tbs_id'] as String;
      final description = question['question_description'] as String;
      bool isChecked = false; // Inicializar según la lógica de tu aplicación

      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Align(
          alignment: Alignment(-1.2, 0),
          child: Text(description),
        ),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
            // Agregar lógica según tu aplicación
          });
        },
      );
    }).toList();
  }

  void submitForm() async {
    final selectedQuestions = jsonResponseCheck
        .where((question) =>  true)
        .toList();

    final selectedQuestionIds = selectedQuestions
        .map<String>((question) => question['tbs_id']!)
        .toList();

    print('gggg  - Selected Question IDs: $selectedQuestionIds');

    // Agregar lógica para la solicitud POST según tu aplicación
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
                        widget.insertId,
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
                    Icons.list,
                    color: Colors.grey,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Troubleshooting',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButtonFormField<WorkOrderUnit>(
              padding: const EdgeInsets.all(10),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
              ),
              value: selectedStatus,
              onChanged: (WorkOrderUnit? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });

                if (newValue != null) {
                  fetchtroubleShooting(widget.insertId, newValue.title_id);
                  fetchWorkOrderAssetList(newValue.title_id);

                  if (workOrderAssetList.isNotEmpty) {
                    setState(() {
                      selectedAsset = workOrderAssetList[0];
                    });
                  }
                }
              },
              items: workOrderUnitList.map<DropdownMenuItem<WorkOrderUnit>>(
                (WorkOrderUnit value) {
                  return DropdownMenuItem<WorkOrderUnit>(
                    value: value,
                    child: Text(value.title_description),
                  );
                },
              ).toList(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buildCheckboxList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                submitForm();
              },
              child: Text('Save List'),
            ),
          ],
        ),
      ),
    );
  }
}
