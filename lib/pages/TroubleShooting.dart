import 'dart:convert';
import 'RedirectTo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TroubleShooting extends StatefulWidget {
  final String insertId;
  final String idUser;
  final String user_type_id;
  final String brand_id;

  const TroubleShooting(
      {required this.insertId,
      required this.idUser,
      required this.user_type_id,
      required this.brand_id,
      Key? key})
      : super(key: key);

  @override
  State<TroubleShooting> createState() => _TroubleShootingState();
}

class WorkOrderUnit {
  final String title_id;
  final String title_description;

  WorkOrderUnit({
    required this.title_id,
    required this.title_description,
  });

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

  bool enableCheckboxes =
      true; // Variable para controlar la habilitación/deshabilitación de los checkboxes
  bool showSaveListButton =
      true; // Variable para controlar la visibilidad del botón
  bool originalResponseHadZero =
      false; // Indicador para rastrear si la respuesta original tenía algún check establecido en 0

  bool hideSaveButton = false;
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
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/Cat_list_get/' +
              widget.insertId),
    );

    print("list category ==>>>>" + response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderUnit> statuses = (data.isNotEmpty && data is List)
          ? data.map((e) => WorkOrderUnit.fromJson(e)).toList()
          : [];

      setState(() {
        workOrderUnitList = statuses;
      });

      //print('Work Order Units:');
      workOrderUnitList.forEach((element) {
        //print('${element.title_id}: ${element.title_description}');
      });
    } else {
      throw Exception('Failed to load work order data');
    }
  }

  // Future<void> fetchWorkOrderAssetList(String siteId) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Unit_asset_post'),
  //     body: {
  //       "site_id": siteId,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     final List<WorkOrderAsset> assets =
  //         data.map((e) => WorkOrderAsset.fromJson(e)).toList();

  //     setState(() {
  //       workOrderAssetList = assets;
  //     });
  //   } else {
  //     throw Exception('Failed to load work order assets');
  //   }
  // }

  Future<void> fetchtroubleShooting(String insertId, String titleId) async {
    //List preguntas
    final postUrl = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/List_questions_post',
    );

    final response = await http.post(
      postUrl,
      body: {
        'tbs_title': titleId,
        'wo_id': insertId,
        'brand_id': widget.brand_id,
      },
    );
    //print('brand-p:  ' + widget.brand_id);
    //print(response.body);
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

          // Actualizar enableCheckboxes en función de la nueva respuesta
          enableCheckboxes = !allChecksTrue();

          // Actualizar showSaveListButton en función de la nueva respuesta
          showSaveListButton = !allChecksOne() || originalResponseHadZero;
        });
      }
    } else {
      // Manejar el error
    }
  }

// Función para verificar si todos los checks son verdaderos
  bool allChecksTrue() {
    return jsonResponseCheck.every((question) => question['check'] == 1);
  }

  // Función para verificar si todos los checks son uno
  bool allChecksOne() {
    return jsonResponseCheck.every((question) => question['check'] == 1);
  }

  int trueChecksCount = 0;

  int countTrueChecks() {
    trueChecksCount =
        jsonResponseCheck.where((question) => question['check'] == 1).length;

    return trueChecksCount;
  }

  Map<String, String> respuestasSeleccionadas = {};

  List<Widget> buildCheckboxList() {
    return jsonResponseCheck.map<Widget>((question) {
      final tbsId = question['tbs_id'] as String;
      final description = question['question_description'] as String;

      // Ajuste aquí: Si el campo 'check' es 1, isChecked es true, de lo contrario, usa el valor almacenado
      bool isChecked = question['check'] == 1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(description),
            ),
            value: isChecked,
            onChanged: enableCheckboxes
                ? (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                      selectedQuestions[tbsId] = isChecked;

                      // También actualizamos el estado general de jsonResponseCheck
                      jsonResponseCheck = List<Map<String, dynamic>>.from(
                          jsonResponseCheck.map((q) {
                        if (q['tbs_id'] == tbsId) {
                          q['check'] = isChecked ? 1 : 0;
                        }
                        return q;
                      }));
                    });
                  }
                : null, // If enableCheckboxes is false, disable the checkbox
          ),
          if (isChecked) // Mostrar el TextField solo si el checkbox está marcado
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Write an answer',
                ),
                onChanged: (text) {
                  // Almacena la respuesta junto con su ID correspondiente
                  respuestasSeleccionadas['desc$tbsId'] = text;
                },
              ),
            ),
        ],
      );
    }).toList();
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                if (message == 'Complete!') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RedirectTo(
                              idUser: widget.idUser,
                              user_type_id: widget.user_type_id,
                              woId: widget.insertId,
                            )),
                  );
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void submitForm(String titleId) async {
    final selectedQuestionIds = selectedQuestions.entries
        .where((entry) => entry.value)
        .map<String>((entry) => entry.key)
        .toList();

    //print('Selected Question IDs: $selectedQuestionIds');
    //print('Selected Answers: $respuestasSeleccionadas');

    try {
      final response = await http.post(
        Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/troubleshooting/In_post',
        ),
        body: {
          'selectedQuestionIds': selectedQuestionIds.join(','),
          'wo_id': widget.insertId,
          'user_id': widget.idUser,
          'tbs_title': titleId,
          'brand_id': widget.brand_id,
          'respuestasSeleccionadas': jsonEncode(respuestasSeleccionadas),
        },
      );

      //print(titleId);
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('msn')) {
          final String message = decodedResponse['msn'];
          showAlert(message);
        }
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
                  //fetchWorkOrderAssetList(newValue.title_id);

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
            Visibility(
              visible: showSaveListButton,
              child: ElevatedButton(
                onPressed: () {
                  submitForm(selectedStatus!.title_id);
                },
                child: Text('Save List'),
                style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2711F3), 
                  padding: const EdgeInsets.all(20),
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
