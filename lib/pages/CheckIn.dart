import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CheckIn extends StatefulWidget {
  final String woId;
  const CheckIn({required this.woId, Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  String woId = '';
  String priority = '';
  String description = '';
  List<String> dropdownItems = ['Seleccione'];
  bool showCheckbox = false;
  List<dynamic> jsonResponse = [];

  String? selectedOption;
  //List<String> items = ['Seleccione', 'Opción 1', 'Opción 2', 'Opción 3'];

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
        setState(() {
          dropdownItems = items.map((item) {
            final description = item['description'] as String;
            final idShift = item['id_shift'].toString();
            // Aquí concatenamos la descripción y el id_shift en un solo valor.
            return "$description ($idShift)";
          }).toList();
        });
      }
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      getLocation();
    } else {
      // Muestra un diálogo que informa al usuario que los permisos son necesarios.
      // showDialog(
        // context: context,
        // builder: (context) {
          // return AlertDialog(
            // title: Text('Permiso denegado'),
            // content: Text(
                // 'Debes conceder permisos de ubicación para obtener la ubicación.'),
            // actions: <Widget>[
              // TextButton(
                // onPressed: () {
                  // Navigator.of(context).pop();
                // },
                // child: Text('Cerrar'),
              // ),
            // ],
          // );
        // },
      // );
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

      // print('Distancia a la ubicación específica: $distanceInMeters metros');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Distancia'),
            content: Text('Estas a $distanceInMeters metros de la ubicacion'),
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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                    print(newValue);
                    // Verificar si la opción seleccionada contiene "(4)" para mostrar el Checkbox
                    showCheckbox =
                        (newValue != null && newValue.contains(" (4)"));
                  });
                },
                items: dropdownItems.map((String value) {
                  if (value == 'choice') {
                    print(value);
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox.shrink(),
                    );
                  } else {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }
                }).toList(),
                icon: Icon(Icons.arrow_drop_down),
                isDense: true,
                underline: Container(),
              ),
            ),

            // Mostrar el Checkbox si showCheckbox es verdadero
            if (showCheckbox)
              Row(
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

            TextField(
              maxLines: 3,
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Write a comment',
                border: OutlineInputBorder(),
              ),
            ),

            // Botón de guardar
            ElevatedButton(
              onPressed: () {
                requestLocationPermission();
              },
              child: Text('Guardar'),
            ),

            // Mostrar la latitud y longitud
            Text(latitude),
            Text(longitude),
          ],
        ),
      ),
    );
  }
}
