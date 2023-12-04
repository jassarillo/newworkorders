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
  String woId = '';
  String priority = '';
  String description = '';
  List<dynamic> jsonResponse = [];
  List<dynamic> jsonResponseCheck = [];

  WorkOrderUnit? selectedStatus;
  WorkOrderAsset? selectedAsset;
  WorkOrderPriority? selectedPriority;
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
    fetchtroubleShooting(widget.insertId);
    fetchWorkOrderUnitList();
  }

  Future<void> fetchtroubleShooting(String insertId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Shift_get/383');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        setState(() {
          jsonResponseCheck = List<List<Map<String, String>>>.from(
            decodedResponse.map(
              (shift) => List<Map<String, String>>.from(
                (shift as List).map(
                  (item) => Map<String, String>.from(item),
                ),
              ),
            ),
          );
        });
      }
    } else {
      // Handle the request error if necessary.
    }
  }

  Future<void> fetchWorkOrderUnitList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/Cat_list_get/408'), //>>>>
    );
    print("==>>>>"+response.body);
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
    http.Response response = await http.post(
        Uri.parse(
            'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Unit_asset_post'),
        body: {
          "site_id": siteId,
        });
//print("gggg    "+response.body);
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

  List<Widget> buildCheckboxList() {
    if (jsonResponseCheck.length < 1) {
      return [];
    }

    final shifts = jsonResponseCheck[0];

    return shifts.map<Widget>((shift) {
      final idShift = shift['id_shift'] as String;
      final description = shift['description'] as String;
      bool isChecked = shift['status'] == 't';

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
            shift['status'] = isChecked ? 't' : 'f';
          });
        },
      );
    }).toList();
  }

  void submitForm() async {
    final selectedShifts = jsonResponseCheck
        .expand((shift) => shift)
        .where((shift) => shift['status'] == 't')
        .toList();

    final selectedShiftIds = selectedShifts
        .map<String>((shift) => shift['id_shift'] as String)
        .toList();

    print('Selected Shift IDs: $selectedShiftIds');

    final postUrl = Uri.parse('http://tu-api.com/endpoint');

    try {
      final response = await http.post(
        postUrl,
        body: json.encode({'selectedShifts': selectedShiftIds}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Successful POST request');
      } else {
        print('Error in POST request: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in POST request: $error');
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
