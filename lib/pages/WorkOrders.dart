import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddNewOrder.dart';

class WorkOrders extends StatefulWidget {
  const WorkOrders({Key? key}) : super(key: key);

  @override
  State<WorkOrders> createState() => _WorkOrdersState();
}

class _WorkOrdersState extends State<WorkOrders> {
List<Map<String, dynamic>> workOrders = [];
  List<Map<String, dynamic>> filteredWorkOrders = [];
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    fetchWorkOrders();
  }

  Future<void> fetchWorkOrders() async {
    final response = await http.get(Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_get'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data is List) {
        setState(() {
          workOrders = List<Map<String, dynamic>>.from(data);
          filteredWorkOrders = List<Map<String, dynamic>>.from(data);
        });
      }
    }
  }
  void filterWorkOrders(String query) {
  setState(() {
    filteredWorkOrders = workOrders
        .where((workOrder) =>
         workOrder['priority']
     .toLowerCase()
     .contains(query.toLowerCase()) ||
            workOrder['wo_description']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            workOrder['wo_id']
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Work Orders',
              style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          MaterialButton(
            padding: const EdgeInsets.all(20),
            minWidth: 5,
            height: 50,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddNewOrder()));
            },
            color: const Color.fromARGB(255, 39, 17, 243),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Add new order',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: TextField(
                     onChanged: (value) {
                       setState(() {
                         searchQuery = value;
                         filterWorkOrders(searchQuery);
                       });
                     },
                     decoration: InputDecoration(
                       prefixIcon: Icon(Icons.search),
                       hintText: 'Search',
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30.0),
                       ),
                     ),
                   ),
                 ),
                 Container(
                   alignment: Alignment.topLeft,
                   padding: const EdgeInsets.all(10),
                   margin: const EdgeInsets.all(10),
                   child: const Text(
                     'ARCHIVE',
                     style: TextStyle(
                       color: Color.fromARGB(255, 5, 5, 5),
                       fontWeight: FontWeight.w500,
                       fontSize: 12,
                     ),
                   ),
                 ),
                 for (final workOrder in filteredWorkOrders)
                   WorkOrderCard(
                     priority: workOrder['priority'] as String,
                     woDescription: workOrder['wo_description'] as String,
                     dueTime: workOrder['due_time'] as String,
                     woId: workOrder['wo_id'] as String,
                     descriptionStatus: workOrder['description'] as String,
                   ),
        ],
      ),
    );
  }
}
Color getColorForPriority(String priority) {
  switch (priority.toLowerCase()) {
    case 'low':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'high':
      return Colors.red;
    case 'critical':
      return Colors.blue;
    default:
      return Colors.grey; // Color por defecto si no coincide con ninguno de los valores anteriores
  }
}


class WorkOrderCard extends StatelessWidget {
  final String woId;
  final String descriptionStatus;
  final String priority;
  final String woDescription;
  final String dueTime;

  const WorkOrderCard({
    Key? key,
    required this.woId,
    required this.descriptionStatus,
    required this.priority,
    required this.woDescription,
    required this.dueTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      child: ListTile(
        title: Wrap(
          alignment: WrapAlignment.spaceBetween, // Espacio entre los elementos
          runSpacing: 2, // Espacio entre las líneas
          children: <Widget>[
            Text(
              '$woId ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold, // Texto en negritas
                fontSize: 20, // Tamaño de fuente
              ),
            ),

            Text(
              '$descriptionStatus ',
              style: TextStyle(color: Colors.blue),
            ),
            Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: getColorForPriority(priority), // Usa la función para obtener el color
            ),
            child: Text(priority, style: TextStyle(color: Colors.white),),
            ),
            
          ],
        ),
        subtitle: Text(woDescription),
        trailing: Text(dueTime),
      ),
    );
  }
}