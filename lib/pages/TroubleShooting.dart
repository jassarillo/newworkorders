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
  List<Map<String, dynamic>> jsonResponseCheck = [];
  Map<String, bool> selectedQuestions = {};

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
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/Cat_list_get/' + widget.insertId), //Primer select
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
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/List_questions_post');

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
        jsonResponseCheck = List<Map<String, dynamic>>.from(
          decodedResponse['getQuestions'].map<Map<String, dynamic>>(
            (question) => Map<String, dynamic>.from(question),
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

    // Ajuste aquí: Si el campo 'check' es 1, isChecked es true, de lo contrario, usa el valor almacenado
    bool isChecked = question['check'] == 1;

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
          selectedQuestions[tbsId] = isChecked;

          // También actualizamos el estado general de jsonResponseCheck
          jsonResponseCheck =
              List<Map<String, dynamic>>.from(jsonResponseCheck.map((q) {
            if (q['tbs_id'] == tbsId) {
              q['check'] = isChecked ? 1 : 0;
            }
            return q;
          }));
        });
      },
    );
  }).toList();
}


  void submitForm(String titleId) async {
    final selectedQuestionIds = selectedQuestions.entries
        .where((entry) => entry.value)
        .map<String>((entry) => entry.key)
        .toList();

    print('Selected Question IDs: $selectedQuestionIds');

    try {
      final response = await http.post(
        Uri.parse(
            'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/In_post'),
        body: {
          'selectedQuestionIds':
              selectedQuestionIds.join(','), // Convertir a una cadena CSV
          'wo_id': widget.insertId,
          'user_id': widget.idUser,
          'tbs_title': titleId,
        },
      );
      print(titleId);
      print(response.body);
      if (response.statusCode == 200) {
        // print('POST request successful');
        print('Response: ${response.body}');
      } else {
        print(
            'Failed to make POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making POST request: $error');
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
                submitForm(selectedStatus!
                    .title_id); // Supongo que selectedStatus no es nulo aquí
              },
              child: Text('Save List'),
            ),
          ],
        ),
      ),
    );
  }
}
