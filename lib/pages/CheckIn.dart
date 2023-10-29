import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? selectedOption;
  List<String> items = ['Seleccione', 'Opción 1', 'Opción 2', 'Opción 3'];

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

  Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();
  if (status.isGranted) {
    getLocation();
  } else {
    // Muestra un diálogo que informa al usuario que los permisos son necesarios.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permiso denegado'),
          content: Text('Debes conceder permisos de ubicación para obtener la ubicación.'),
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


  @override
  void initState() {
    super.initState();
    fetchWorkOrderDetailsMessages(widget.woId);

    // Obtener la ubicación al inicio
    getLocation();
  }

  Future<void> fetchWorkOrderDetailsMessages(String woId) async {
    // Implementar tu lógica de obtención de detalles de la orden de trabajo aquí
  }

  // Método para obtener la ubicación
  void getLocation() async {
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // ... (código existente)
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

            // Campo de selección (DropDown)
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Campo de casilla de verificación (CheckBox)
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

            // Campo de área de texto
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
