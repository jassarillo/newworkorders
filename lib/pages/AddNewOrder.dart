import 'package:flutter/material.dart';

class AddNewOrder extends StatefulWidget {
  const AddNewOrder({Key? key}) : super(key: key);

  @override
  State<AddNewOrder> createState() => _AddNewOrderState();
}
class WorkOrderStatus {
  final String wostatusId;
  final String description;

  WorkOrderStatus({required this.wostatusId, required this.description});
}



/*////////////// //////// */
class _AddNewOrderState extends State<AddNewOrder> {

   // Lista de opciones de estado de la orden de trabajo
  List<WorkOrderStatus> workOrderStatusList = [
    WorkOrderStatus(wostatusId: "1", description: "Open"),
    WorkOrderStatus(wostatusId: "2", description: "Assigned"),
    WorkOrderStatus(wostatusId: "3", description: "Closed"),
  ];

  // Variable para almacenar la opción seleccionada
  WorkOrderStatus? selectedStatus;
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Selecciona el estado de la orden de trabajo:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              DropdownButton<WorkOrderStatus>(
                value: selectedStatus,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
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
              SizedBox(height: 20),
              Text(
                'Estado seleccionado: ${selectedStatus?.description ?? "Ninguno"} valor del estado: ${selectedStatus?.wostatusId ?? ""}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
