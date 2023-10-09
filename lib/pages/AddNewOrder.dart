import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart'; //este es para el datepicker scrolling
import 'package:intl/intl.dart';

class AddNewOrder extends StatefulWidget {
  const AddNewOrder({Key? key}) : super(key: key);

  @override
  State<AddNewOrder> createState() => _AddNewOrderState();
}

class WorkOrderStatus {
  final String wostatusId;
  final String description;

  WorkOrderStatus({required this.wostatusId, required this.description});

  factory WorkOrderStatus.fromJson(Map<String, dynamic> json) {
    return WorkOrderStatus(
      wostatusId: json['site_id'],
      description: json['unit'],
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

class _AddNewOrderState extends State<AddNewOrder> {
  List<WorkOrderStatus> workOrderStatusList = [];
  List<WorkOrderPriority> workOrderPriorityList = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController problemController = TextEditingController();

  WorkOrderStatus? selectedStatus;
  WorkOrderPriority? selectedPriority;
  DateTime? selectedDate;
  String problem = '';

  @override
  void initState() {
    super.initState();
    fetchWorkOrderStatusList();
  }

  /*DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }*/
  Future<void> fetchWorkOrderStatusList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Catalog_get'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderStatus> statuses = (data.isNotEmpty &&
              data[0] is List)
          ? (data[0] as List).map((e) => WorkOrderStatus.fromJson(e)).toList()
          : [];
      final List<WorkOrderPriority> priorities = (data.isNotEmpty &&
              data[1] is List)
          ? (data[1] as List).map((e) => WorkOrderPriority.fromJson(e)).toList()
          : [];

      setState(() {
        workOrderStatusList = statuses;
        workOrderPriorityList = priorities;
      });
    } else {
      throw Exception('Failed to load work order data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            DropdownButtonFormField<WorkOrderStatus>(
              decoration: const InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
                // Puedes personalizar el estilo de la etiqueta aquí si es necesario.
              ),
              value: selectedStatus,
              onChanged: (WorkOrderStatus? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              items: workOrderStatusList.map<DropdownMenuItem<WorkOrderStatus>>(
                (WorkOrderStatus value) {
                  return DropdownMenuItem<WorkOrderStatus>(
                    value: value,
                    child: Text(value.description),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Asset',
                  border: OutlineInputBorder(),
                  hintText: 'Write...',
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<WorkOrderPriority>(
              decoration: const InputDecoration(
                labelText: 'Criticality',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
              ),
              value: selectedPriority,
              onChanged: (WorkOrderPriority? newValue) {
                setState(() {
                  selectedPriority = newValue;
                });
              },
              items: workOrderPriorityList
                  .map<DropdownMenuItem<WorkOrderPriority>>(
                (WorkOrderPriority value) {
                  return DropdownMenuItem<WorkOrderPriority>(
                    value: value,
                    child: Text(value.priority),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Select a Date',
                border: OutlineInputBorder(),
                hintText: 'Select a date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
              readOnly:
                  true, // Para evitar la edición manual del campo de fecha.
              controller: TextEditingController(
                text: selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : '',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              controller: problemController,
              decoration: const InputDecoration(
                labelText: 'Problem',
                border: OutlineInputBorder(),
                hintText: 'Escribe aquí...',
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              padding: const EdgeInsets.all(20),
              minWidth: 5,
              height: 50,
              onPressed: () async {
                setState(() {
                  problem = problemController.text;
                });
                /**  ---------  **/
                http.Response response = await http.post(
                    Uri.parse(
                        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_post'),
                    body: {
                      "wo_unit": selectedStatus?.wostatusId,
                      "wo_asset": "14",
                      "wo_priority": selectedPriority?.priorityId,
                      "wo_problem": problem,
                      "user_id": "9",
                      "wo_due_date": selectedDate != null
                          ? _dateFormat.format(selectedDate!)
                          : '',
                    });
                print(response.statusCode);
                if (response.statusCode == 200) {
                  const succesMessage = "New work order created successfully!";
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Success!"),
                        content: const Text(succesMessage),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Accept"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog.
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  const errorMessage = " We have a problem  :(";
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error!"),
                        content: const Text(errorMessage),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Accept"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Cierra el AlertDialog.
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                /**  ---------  **/
              },
              color: const Color.fromARGB(255, 39, 17, 243),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 10),
                  Text(
                    'Guardar Work Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            /*SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime(1969, 1, 1),
                onDateTimeChanged: (DateTime newDateTime) {
                  // Do something
                },
              ),
            ),*/
            Text(
              ' ${selectedStatus?.description ?? "Ninguno"} valor del estado: ${selectedStatus?.wostatusId ?? ""}<borrar>',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              ' ${selectedPriority?.priority ?? "Ninguno"} valor del estado: ${selectedPriority?.priorityId ?? ""}<borrar>',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
