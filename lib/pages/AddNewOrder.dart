import 'dart:io';
import 'dart:convert';
import 'TroubleShooting.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddNewOrder extends StatefulWidget {
  final String idUser;
  final String user_type_id;

  const AddNewOrder(
      {Key? key, required this.idUser, required this.user_type_id})
      : super(key: key);

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
  int insertId = 0;
  int brand_id = 0;
  //XFile? _selectedImage;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    fetchWorkOrderUnitList();
    imagePicker = ImagePicker();
  }

  List<XFile>? imageFileList = [];

  void selectImages() async {
    try {
      print('peticion btn...');
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      print('XFile');
      if (selectedImages != null && selectedImages.isNotEmpty) {
        print('if selected ims');
        imageFileList!.addAll(selectedImages);
        setState(() {});
      } else {
        // El usuario canceló la selección de imágenes
        print('Selección de imágenes cancelada.');
      }
    } catch (e) {
      // Manejar la excepción
      print('Error al seleccionar imágenes: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Error al seleccionar imágenes."),
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

  void removeImage(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }

  Future<void> _uploadImageAndSaveOrder() async {
    if (imageFileList!.length >= 3) {
      //Si hay imagenes hace la carga
      if (selectedStatus?.woStatusId == null ||
          selectedAsset?.woUitId == null ||
          selectedPriority?.priorityId == null ||
          problem.isEmpty ||
          selectedDate == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("All inputs are required!"),
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
        return; // Detener la solicitud POST
      }
      final Uri url = Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_post');
      final request = http.MultipartRequest('POST', url);

      request.fields['wo_unit'] = selectedStatus?.woStatusId ?? '';
      request.fields['wo_asset'] = selectedAsset?.woUitId ?? '';
      request.fields['wo_priority'] = selectedPriority?.priorityId ?? '';
      request.fields['wo_problem'] = problem;
      request.fields['user_id'] = widget.idUser;
      request.fields['wo_due_date'] =
          selectedDate != null ? _dateFormat.format(selectedDate!) : '';

      if (imageFileList != null) {
        for (final image in imageFileList!) {
          final imageFile = File(image.path);
          final fileName = imageFile.path.split('/').last;
          //print('Nombre del archivo: $fileName');
          request.files.add(http.MultipartFile(
            'images[]', // El nombre del campo que acepta múltiples imágenes en el servidor
            imageFile.openRead(),
            imageFile.lengthSync(),
            filename: imageFile.path.split('/').last, // Nombre del archivo
          ));
        }
        //print(imageFileList);
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        //print(responseBody);
        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          insertId = data['insert_id'];
          brand_id = data['brand_id'];
          final exitMessage = "New work order created Id: $insertId";
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Message"),
                content: Text(exitMessage),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Accept"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      // Navega a TroubleShooting.dart con insertId como parámetro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TroubleShooting(
                            insertId: insertId.toString(),
                            idUser: widget.idUser,
                            user_type_id: widget.user_type_id,
                            brand_id: brand_id.toString(),
                          ),
                        ),
                      );
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
                content: const Text("Error to upload images!"),
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Error uploading images and saving the order: $e"),
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
    } else if (imageFileList!.length < 3) {
      // Less than 3 images selected
      _showAlertDialog(
          'Error', 'Please select at least three images before saving.');
      return;
    } else {
      //Alert cargar imagenes
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("Please select at least one image before saving."),
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
      return;
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchWorkOrderUnitList() async {
    final response = await http.get(
      Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Catalog_get'),
    );
    //print(">>> " + response.body);
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
    //print("Unit_asset_post");
    //print(response.statusCode);
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: const Text(
                  'New Work Order',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Order number",
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
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
              Container(
                constraints:
                    BoxConstraints(maxWidth: 350), // Establece un ancho máximo
                child: DropdownButtonFormField<WorkOrderAsset>(
                  decoration: const InputDecoration(
                    labelText: 'Asset',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0), // Ajusta el espaciado
                  ),
                  value: selectedAsset,
                  onChanged: (WorkOrderAsset? newValue) {
                    setState(() {
                      selectedAsset = newValue;
                    });
                  },
                  isExpanded:
                      true, // Permite que el DropdownButtonFormField ocupe el ancho máximo disponible
                  items:
                      workOrderAssetList.map<DropdownMenuItem<WorkOrderAsset>>(
                    (WorkOrderAsset value) {
                      return DropdownMenuItem<WorkOrderAsset>(
                        value: value,
                        child: Text(value.AssetName),
                      );
                    },
                  ).toList(),
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
                readOnly: true,
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
                  hintText: 'Write here...',
                ),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  if (imageFileList!.length >= 5) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Limit of images reached"),
                          content: const Text(
                              "No more than 5 images can be selected."),
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
                  } else {
                    selectImages();
                  }
                },
                child: const Text('Select Multiple Images'),
              ),
              if (imageFileList!.isNotEmpty)
                Container(
                  height: 200, // Establece una altura máxima para el GridView
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columnas
                    ),
                    itemCount: imageFileList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          removeImage(index);
                        },
                        child: Stack(
                          children: [
                            Image.file(
                              File(imageFileList![index].path),
                              fit: BoxFit.cover,
                            ),
                            const Positioned(
                              top: 3,
                              right: 3,
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Save Work Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //jjkkjkkjk
      ),
    );
  }
}