import 'dart:convert';
import '../RedirectTo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class Quotation extends StatefulWidget {
  final String woId;
  final String idUser;
  final String user_type_id;
  const Quotation({
    required this.woId,
    required this.idUser,
    required this.user_type_id,
    Key? key,
  }) : super(key: key);

  @override
  State<Quotation> createState() => _QuotationState();
}

class _QuotationState extends State<Quotation> {
  dynamic selectedWoId;
  List<dynamic> jsonResponse = [];
  List<dynamic> filteredWorkOrders = [];
  //String vendor_name = '';
  String cost = '';
  String filePath = '';
  String selectedFileName = '';
  String? selectedVendorId;
  List<Map<String, dynamic>> vendors = [];
  final TextEditingController costController = TextEditingController();

  Future<void> _refresh() async {
    await fetchQuotationsList(widget.woId);
  }

  @override
  void initState() {
    super.initState();
    fetchQuotationsList(widget.woId);
    loadVendors(widget.woId);
  }

  Future<List<Map<String, dynamic>>> loadVendors(String woId) async {
    final response = await http.get(Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/List_get/$woId'));

    //print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty && data[0] != null) {
        final List<dynamic> vendorsData = data[0];
        vendors = List<Map<String, dynamic>>.from(vendorsData);
        return vendors;
      } else {
        throw Exception('Respuesta de JSON vacía o mal formateada');
      }
    } else {
      throw Exception(
          'Error al cargar los vendedores. Código: ${response.statusCode}');
    }
  }

  Future<void> pickFile() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
    }

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          filePath = result.files.single.path!;
          selectedFileName = result.files.single.name ?? '';
        });
      }
    } else {
      print('Permiso denegado para acceder al almacenamiento.');
    }
  }

  Future<void> fetchQuotationsList(String woId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/Listquo_get/$woId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(response.body);
      });
    }
  }

  List<Widget> buildQuotationCards() {
    if (jsonResponse == null ||
        jsonResponse.isEmpty ||
        jsonResponse[0] == null) {
      return [];
    }
    List<dynamic> localQuotations;

    if (filteredWorkOrders.isNotEmpty) {
      localQuotations = List.from(filteredWorkOrders);
    } else {
      localQuotations = List.from(jsonResponse[0]);
    }

    return localQuotations.map<Widget>((quotation) {
      final quotationId = quotation['quotation_id'].toString();
      final vendorName = quotation['vendor_name'] as String?;
      final urlFile = quotation['url'] as String?;
      final declined = quotation['declined'] as String?;

      bool isDeclined = declined == '1';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        child: GestureDetector(
          onTap: () async {
            if (vendorName != null && urlFile != null) {
              await launchUrl(Uri.parse(
                  'http://srv406820.hstgr.cloud/mainthelpdev/' + urlFile));
            }
          },
          child: Card(
            color: isDeclined == true ? Colors.grey : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 2,
                children: <Widget>[
                  AbsorbPointer(
                    absorbing: isDeclined == true,
                    child: Radio(
                      value: quotationId,
                      groupValue: selectedWoId,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedWoId = value;
                        });
                        requestApproval(value);
                      },
                      // Disable the Radio button when isDeclined is true
                      // (i.e., declined is equal to 1)
                      // If declined is null or false, the Radio button is enabled.
                      materialTapTargetSize: isDeclined == true
                          ? MaterialTapTargetSize.shrinkWrap
                          : MaterialTapTargetSize.padded,
                      // Adjust the size of the tap target accordingly
                    ),
                  ),
                  Text(
                    vendorName ?? 'No description available',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              subtitle: Text("Date: ${quotation['date']}"),
              trailing: urlFile != null && urlFile.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (vendorName != null && urlFile != null) {
                          await launchUrl(Uri.parse(
                              'http://srv406820.hstgr.cloud/mainthelpdev/' +
                                  urlFile));
                        }
                      },
                      child: Icon(
                        Icons.description,
                        color: Colors.blue,
                      ),
                    )
                  : Icon(
                      Icons.description,
                      color: Colors.grey,
                    ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> saveData() async {
    if (selectedVendorId == null) {
      return;
    }
    // print('save datos');
    final url = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/In_post',
    );

    var request = http.MultipartRequest('POST', url)
      ..fields['user_id'] = widget.idUser
      ..fields['wo_id'] = widget.woId
      ..fields['vendeo_id'] = selectedVendorId ?? ''
      ..fields['cost'] = costController.text
      ..files.add(
        await http.MultipartFile.fromPath(
          'pdf',
          filePath,
        ),
      );

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    print('save...' + response.body);
    if (response.statusCode == 200) {
      // Maneja el caso de éxito, por ejemplo, muestra una alerta.
      // Navega a WODetail.dart utilizando Navigator.push
    } else {
      print('Error al guardar los datos. Código: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');
    }
  }

  Future<void> requestApproval(String quotationId) async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/Request_approval_post',
        ),
        body: {
          'wo_id': widget.woId,
          'quotation_id': quotationId,
          'user_id': widget.idUser,
        },
      );
      print('insert radio check kk--> ' + response.body);
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          final String message = decodedResponse['msn'];
          final int tipo = decodedResponse['tipo'];

          if (tipo == 1) {
            // El tipo es 1, muestra un AlertDialog con el mensaje y navega a WODetail
            showAlert(message, tipo);
          } else {
            // El tipo no es 1, puedes manejarlo según tus necesidades
            print('Tipo no es 1');
          }
        }
      } else {
        print(
            'Failed to make POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making POST request: $error');
    }
  }

  void showAlert(String message, int tipo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                if (tipo == 1) {
                  // Navegar a WODetail.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RedirectTo(
                        idUser: widget.idUser,
                        user_type_id: widget.user_type_id,
                        woId: widget.woId,
                      ), // Ajusta esto según tus necesidades
                    ),
                  );
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Función para la API 'Approval_mm_post'
  Future<void> approveQuo() async {
    try {
      print(' woid-   ' + widget.woId  + widget.idUser + ' usertype- ' +widget.user_type_id);

      print('intenta aprobar');
      final response = await http.post(
        Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/Approval_mm_post',
        ),
        body: {
          'wo_id': widget.woId,
          'quotation_id': '22',
          'user_id': widget.idUser,
          'user_type_id': widget.user_type_id,
        },
      );
      print('aprobar -- ' + response.body);
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          final String message = decodedResponse['msn'];
          final int tipo = decodedResponse['tipo'];

          if (tipo == 1) {
            showAlert(message, tipo);
          } else {
            print('Tipo no es 1');
          }
        }
      } else {
        print(
            'Failed to make POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making POST request: $error');
    }
  }

// Función para la API 'Decline_mm_post'
  Future<void> cancelQuo() async {
    try {
      final response = await http.post(
        Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/quotations/Decline_mm_post',
        ),
        body: {
          'wo_id': widget.woId,
          'quotation_id': '22',
          'user_id': widget.idUser,
          'user_type_id': widget.user_type_id,
        },
      );
      print('cancelar -- ' + response.body);

      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is Map<String, dynamic>) {
          final String message = decodedResponse['msn'];
          final int tipo = decodedResponse['tipo'];

          if (tipo == 1) {
            showAlert(message, tipo);
          } else {
            print('Tipo no es 1');
          }
        }
      } else {
        print(
            'Failed to make POST request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making POST request: $error');
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
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.grey.shade200,
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
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.woId,
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
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
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Quotation',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: selectedVendorId,
                  onChanged: (value) {
                    setState(() {
                      selectedVendorId = value;
                    });
                  },
                  items: vendors
                      .map<DropdownMenuItem<String>>(
                        (vendor) => DropdownMenuItem<String>(
                          value: vendor['vendor_id'].toString(),
                          child: Text(vendor['vendor_name'].toString()),
                        ),
                      )
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Vendor',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: costController,
                  decoration: InputDecoration(
                    labelText: 'Cost',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: pickFile,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(3.0),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(10.0),
                    ),
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_upload,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Select File',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              'Selected File: $selectedFileName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(20),
              minWidth: 5,
              height: 50,
              onPressed: saveData, // Aquí se llama al método saveData
              color: const Color.fromARGB(255, 39, 17, 243),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los botones en el espacio disponible
              children: [
                ElevatedButton(
                  onPressed: () {
                    approveQuo();
                  },
                  child: Text('Approve Quo'),
                ),
                SizedBox(width: 20), // Agrega un espacio entre los botones
                ElevatedButton(
                  onPressed: () {
                    cancelQuo();
                  },
                  child: Text('Cancel Quo'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                //padding: const EdgeInsets.all(20),
                child: Column(
                  children: buildQuotationCards(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
