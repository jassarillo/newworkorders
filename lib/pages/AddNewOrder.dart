import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      wostatusId: json['wostatus_id'],
      description: json['description'],
    );
  }
}

class _AddNewOrderState extends State<AddNewOrder> {
  List<WorkOrderStatus> workOrderStatusList = [];

  WorkOrderStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    fetchWorkOrderStatusList();
  }

  Future<void> fetchWorkOrderStatusList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Catalog_get'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderStatus> statuses = (data.isNotEmpty &&
              data[0] is List)
          ? (data[0] as List).map((e) => WorkOrderStatus.fromJson(e)).toList()
          : [];
      setState(() {
        workOrderStatusList = statuses;
      });
    } else {
      throw Exception('Failed to load work order statuses');
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
            const SizedBox(height: 20),
             const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        
            DropdownButtonFormField<WorkOrderStatus>(
              decoration: const InputDecoration(
                labelText: 'Seleccione Unit  1',
                border: OutlineInputBorder(),
                contentPadding:  EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
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
            const SizedBox(height: 20),
           
            const SizedBox(height: 20),
            Text(
              ' ${selectedStatus?.description ?? "Ninguno"} valor del estado: ${selectedStatus?.wostatusId ?? ""}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
