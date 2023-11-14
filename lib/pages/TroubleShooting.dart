import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TroubleShooting extends StatefulWidget {
  final String woId;
  const TroubleShooting({required this.woId, Key? key}) : super(key: key);

  @override
  State<TroubleShooting> createState() => _TroubleShootingState();
}

class _TroubleShootingState extends State<TroubleShooting> {
  String woId = '';
  String priority = '';
  String description = '';
  List<dynamic> jsonResponse = [];
  List<dynamic> jsonResponseCheck = [];

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
    fetchWorkOrderDetailsMessages(widget.woId);
    fetchtroubleShooting(widget.woId);
  }

  Future<void> fetchWorkOrderDetailsMessages(String woId) async {
    final url = Uri.parse(
        // 'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Comments_get/$woId');
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Comments_get/0');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse.length > 1) {
        final woData = jsonResponse[0][0];
        // final comments = jsonResponse[1];

        setState(() {
          this.woId = woId;
          this.priority = priority;
          this.description = description;
        });
      }
    }
  }
Future<void> fetchtroubleShooting(String woId) async {
  final url = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Shift_get/');
  final response = await http.get(url);
  print(response);
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
    // Manejar el error de la petición, si es necesario.
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
  // Filtra los elementos seleccionados
  final selectedShifts = jsonResponseCheck
      .expand((shift) => shift)
      .where((shift) => shift['status'] == 't')
      .toList();

  // Prepara la lista de IDs de los elementos seleccionados
  final selectedShiftIds =
      selectedShifts.map<String>((shift) => shift['id_shift'] as String).toList();

  // Puedes imprimir la lista de IDs para verificar
  print('Selected Shift IDs: $selectedShiftIds');

  // URL para la solicitud POST, ajusta según tu API
  final postUrl = Uri.parse('http://tu-api.com/endpoint');

  try {
    // Realiza la solicitud POST
    final response = await http.post(
      postUrl,
      body: json.encode({'selectedShifts': selectedShiftIds}),
      headers: {'Content-Type': 'application/json'},
    );

    // Verifica la respuesta del servidor
    if (response.statusCode == 200) {
      print('Solicitud POST exitosa');
    } else {
      print('Error en la solicitud POST: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en la solicitud POST: $error');
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
            Navigator.of(context).pop(); // Esta línea permite retroceder
          },
          icon: const Icon(
              Icons.arrow_back), // Cambia el ícono a una flecha hacia atrás
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
                    'Troubleshooting***',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
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
