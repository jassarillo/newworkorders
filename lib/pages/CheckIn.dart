import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckIn extends StatefulWidget {
  final String woId;
  final String idUser;

  const CheckIn({required this.woId, required this.idUser, Key? key})
      : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class WorkOrderUnit {
  final String description;
  final String idShift;

  WorkOrderUnit(this.description, this.idShift);
}

class _CheckInState extends State<CheckIn> {
  String woId = '';
  String priority = '';
  String description = '';
  List<String> dropdownItems = ['Seleccione'];
  bool showCheckbox = false;
  List<dynamic> jsonResponse = [];
  List<WorkOrderUnit> workOrderUnitList = [WorkOrderUnit('Seleccione', '0')];

  WorkOrderUnit? selectedOption;

  bool isChecked = false;
  TextEditingController commentController = TextEditingController();

  String latitude = 'Latitud: -';
  String longitude = 'Longitud: -';

  Color getColorForPriority(String priority) {
    if (priority == 'high') {
      return Colors.red;
    } else if (priority == 'medium') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  Future<void> fetchDropdownItems() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Shift_get/'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        final items = data[0] as List;
        final workOrderUnits = items.map((item) {
          final description = item['description'] as String;
          final idShift = item['id_shift'].toString();
          return WorkOrderUnit(description, idShift);
        }).toList();

        setState(() {
          workOrderUnitList = workOrderUnits;
        });
      }
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getLocation();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Permiso denegado'),
            content: Text(
                'Debes conceder permisos de ubicación para obtener la ubicación.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      // Calcula la distancia entre la ubicación actual y la ubicación específica
      double distanceInMeters = await Geolocator.distanceBetween(
          position.latitude, position.longitude, 19.426314, -98.877709);

      print('Distancia aproximada: $distanceInMeters metros');

      setState(() {
        latitude = 'Latitud: ${position.latitude}';
        longitude = 'Longitud: ${position.longitude}';
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkOrderDetailsMessages(widget.woId);
    fetchDropdownItems();
    getLocation();
    fetchWorkOrderDetailsHeader(widget.woId);
  }

  Future<void> fetchWorkOrderDetailsMessages(String woId) async {
    // Implementar tu lógica de obtención de detalles de la orden de trabajo aquí
  }

  // Método para obtener la ubicación
  void fetchLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latitude = 'Latitud: ${position.latitude}';
        longitude = 'Longitud: ${position.longitude}';
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  List<Widget> buildCommentCards() {
    // Implementar la generación de tarjetas de comentarios aquí
    return [];
  }

  Future<void> fetchWorkOrderDetailsHeader(String woId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Comments_get/$woId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse.length > 1) {
        final woData = jsonResponse[0][0];
        final comments = jsonResponse[1];
        final woId = woData['wo_id'] as String;
        final priority = woData['priority'] as String;
        final description = woData['description'] as String;
        setState(() {
          this.woId = woId;
          this.priority = priority;
          this.description = description;
        });
      }
    }
  }

  Future<void> submitForm() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = await Geolocator.distanceBetween(
          position.latitude, position.longitude, 19.426314, -98.877709);

      final Map<String, dynamic> formData = {
        'woId': woId, // Agregamos el campo woId
        'shift': {
          'description': selectedOption?.description,
          'idShift': selectedOption?.idShift,
        },
        'id_shift': selectedOption?.idShift,
        'checkboxValue': isChecked,
        'comment': commentController.text,
        'latitude': latitude,
        'longitude': longitude,
        'proximity': distanceInMeters.toString(), // Convertimos a String
      };

      final response = await http.post(
        Uri.parse(
            'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Check_in_post'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formData),
      );
      //print(formData);
      //print(response.body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success!"),
              content: const Text("Successful registration."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Failed registration."),
              actions: <Widget>[
                TextButton(
                  child: const Text("Accept"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("An error occurred."),
            actions: <Widget>[
              TextButton(
                child: const Text("Accept"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
                        this.woId,
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          'Status',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 5),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          'Priority',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 5, 5),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: getColorForPriority(priority),
                          ),
                          child: Text(
                            priority,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          child: const Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'CHECK IN',
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
                            labelText: 'Seleccione',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 1.0),
                          ),
                          value: selectedOption,
                          onChanged: (WorkOrderUnit? newValue) {
                            setState(() {
                              selectedOption = newValue;
                              showCheckbox =
                                  (newValue != null && newValue.idShift == "4");
                            });
                          },
                          items: workOrderUnitList
                              .map<DropdownMenuItem<WorkOrderUnit>>(
                            (WorkOrderUnit value) {
                              return DropdownMenuItem<WorkOrderUnit>(
                                value: value,
                                child: Text(value.description),
                              );
                            },
                          ).toList(),
                        ),
                        Visibility(
                          visible: showCheckbox,
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                              Text('Last visit'),
                            ],
                          ),
                        ),
                        Visibility(
                          visible:
                              showCheckbox && selectedOption?.idShift == "4",
                          child: TextField(
                            maxLines: 3,
                            controller: commentController,
                            decoration: InputDecoration(
                              labelText: 'Write a comment',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),

                     ElevatedButton(
  onPressed: () {
    if (showCheckbox && isChecked) {
      // Si el checkbox está activado, verificar el campo de comentarios
      if (commentController.text.isEmpty) {
        // El campo de comentarios está vacío, muestra un mensaje de error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Debes escribir un comentario."),
              actions: <Widget>[
                TextButton(
                  child: Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; // Salir de la función si hay un error
      }
    }

    // Continuar con la lógica de envío del formulario
    requestLocationPermission();
    submitForm();
  },
  child: Text('Punch In'),
),

                        /*Text(latitude),
                        Text(longitude),*/
                        // Agregar otros widgets que desees dentro del SingleChildScrollView
                      ],
                    ),
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
