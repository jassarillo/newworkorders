import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart'; //este es para el datepicker scrolling
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewOrder extends StatefulWidget {
  const AddNewOrder({Key? key}) : super(key: key);

  @override
  State<AddNewOrder> createState() => _AddNewOrderState();
}

class WorkOrderUnit {
  final String woStatusId;
  final String description;

  WorkOrderUnit({required this.woStatusId, required this.description});

  factory WorkOrderUnit.fromJson(Map<String, dynamic> json) {
    return WorkOrderUnit(
      woStatusId: json['site_id'],
      description: json['unit'],
    );
  }
}

/** */
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
/** */

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
  List<WorkOrderUnit> workOrderUnitList = [];
  List<WorkOrderPriority> workOrderPriorityList = [];
  List<WorkOrderAsset> workOrderAssetList = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController problemController = TextEditingController();

  WorkOrderUnit? selectedStatus;
  WorkOrderAsset? selectedAsset;
  WorkOrderPriority? selectedPriority;
  DateTime? selectedDate;
  String problem = '';
  XFile? _selectedImage;
  @override
  void initState() {
    super.initState();
    fetchWorkOrderUnitList();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _uploadImageAndSaveOrder() async {
    if (_selectedImage == null) {
      // Mostrar un mensaje de error si no se selecciona una imagen.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Por favor, selecciona una imagen antes de guardar."),
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
      return;
    }

    //Envía la imagen al servidor.
    final Uri url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_post');
    //'http://localhost/PHP/upload.php');
    final request = http.MultipartRequest('POST', url);
    request.fields['wo_unit'] = selectedStatus?.woStatusId ?? '';
    request.fields['wo_asset'] = selectedAsset?.woUitId ?? '';
    request.fields['wo_priority'] = selectedPriority?.priorityId ?? '';
    request.fields['wo_problem'] = problem;
    request.fields['user_id'] = '9';
    request.fields['wo_due_date'] =
        selectedDate != null ? _dateFormat.format(selectedDate!) : '';

    final imageFile = File(_selectedImage!.path);
    //print(imageFile.path);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

/* final Uri url = Uri.parse('http://localhost/PHP/upload.php');
    final Uri url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_post');
    final request = http.MultipartRequest('POST', url);
    request.fields['wo_unit'] = selectedStatus?.woStatusId ?? '';
    request.fields['wo_asset'] = selectedAsset?.woUitId ?? '';
    request.fields['wo_priority'] = selectedPriority?.priorityId ?? '';
    request.fields['wo_problem'] = problem;
    request.fields['user_id'] = '9';
    request.fields['wo_due_date'] =
        selectedDate != null ? _dateFormat.format(selectedDate!) : '';

    final imageFile = File(_selectedImage!.path);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

// Enviar la solicitud
    final response = await request.send();

// Leer y imprimir la respuesta
    final responseBody = await response.stream.bytesToString();
    print(responseBody);
*/
    try {
      final response = await request.send();
      //print(response.toString());
      if (response.statusCode == 200) {
        const exitMessage = "Success!";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Message"),
              content: const Text(exitMessage),
              actions: <Widget>[
                TextButton(
                  child: const Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el AlertDialog.
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Maneja el error si la solicitud no es exitosa.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content:
                  const Text("Error al cargar la imagen y guardar la orden."),
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
      }
    } catch (e) {
      // Maneja el error si hay una excepción.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Error al cargar la imagen y guardar la orden: $e"),
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
    }
  }

  Future<void> fetchWorkOrderUnitList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Catalog_get'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<WorkOrderUnit> statuses = (data.isNotEmpty && data[0] is List)
          ? (data[0] as List).map((e) => WorkOrderUnit.fromJson(e)).toList()
          : [];
      final List<WorkOrderPriority> priorities = (data.isNotEmpty &&
              data[1] is List)
          ? (data[1] as List).map((e) => WorkOrderPriority.fromJson(e)).toList()
          : [];

      setState(() {
        workOrderUnitList = statuses;
        workOrderPriorityList = priorities;
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
    print(response.statusCode);
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
/* */

/* */
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            DropdownButtonFormField<WorkOrderUnit>(
              decoration: const InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
                // Puedes personalizar el estilo de la etiqueta aquí si es necesario.
              ),
              value: selectedStatus,
              onChanged: (WorkOrderUnit? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });

                if (newValue != null) {
                  fetchWorkOrderAssetList(newValue.woStatusId);
                  // Cuando obtengas la lista de activos, selecciona el primero por defecto
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
                    child: Text(value.description),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<WorkOrderAsset>(
              decoration: const InputDecoration(
                labelText: 'Asset',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 1.0),
              ),
              value: selectedAsset,
              onChanged: (WorkOrderAsset? newValue) {
                setState(() {
                  selectedAsset = newValue;
                });
              },
              items: workOrderAssetList.map<DropdownMenuItem<WorkOrderAsset>>(
                (WorkOrderAsset value) {
                  return DropdownMenuItem<WorkOrderAsset>(
                    value: value,
                    child: Text(value.AssetName),
                  );
                },
              ).toList(),
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
            /** */
            _selectedImage != null
                ? Image.file(
                    File(_selectedImage!.path),
                    width: 150,
                    height: 150,
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Seleccionar de la galería'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(); // Llamar a la función para seleccionar de la galería
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text('Tomar una foto'),
                          onTap: () {
                            Navigator.pop(context);
                            _takePhoto(); // Llamar a la función para tomar una foto
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Add Photo',
                style: TextStyle(fontSize: 40),
              ),
            ),
            /** */

            const SizedBox(height: 10),
            TextField(
              maxLines: 1,
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
                _uploadImageAndSaveOrder();
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
            /*Text(
              ' ${selectedStatus?.description ?? "Ninguno"} valor del estado: ${selectedStatus?.woStatusId ?? ""}<borrar>',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              ' ${selectedPriority?.priority ?? "Ninguno"} valor del estado: ${selectedPriority?.priorityId ?? ""}<borrar>',
              style: const TextStyle(fontSize: 18),
            ),*/
          ],
        ),
      ),
    );
  }
}
