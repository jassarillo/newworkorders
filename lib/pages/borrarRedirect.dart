import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class RedirecTo extends StatelessWidget {
  final String idUser;
  final String user_type_id;
  
  const RedirecTo({
    required this.user_type_id,
    required this.idUser,
    Key? key,
  }) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  final String woId;
  final String idUser;
  final String user_type_id;

  const MyStatefulWidget({
    required this.idUser,
    required this.woId,
    required this.user_type_id,
    Key? key,
  }) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(user_type_id);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final String user_type_id;

  _MyStatefulWidgetState(this.user_type_id);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String latitude = 'Latitud: -';
  String longitude = 'Longitud: -';

  void fetchWorkOrderDetails(String woId, String idUser) async {
  try {
    final response = await http.get(Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_get/400/1/1'));
print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> workOrders = json.decode(response.body);

      if (workOrders.isNotEmpty) {
        final Map<String, dynamic> workOrder = workOrders.first;
/*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WODetail(
              woId: workOrder['wo_id'],
              priority: workOrder['priority'],
              idUser: widget.idUser, // Corrección aquí
              latitude: this.latitude,
              longitude: this.longitude,
              user_type_id: this.user_type_id,
              site_id: workOrder['site_id'],
            ),
          ),
        );*/
      }
    } else {
      // Manejar el error de la solicitud, si es necesario
    }
  } catch (e) {
    // Manejar excepciones, si es necesario
  }
}


  @override
  void initState() {
    super.initState();
    //getLocation();
  }

  Future<void> getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 300, 30),
            child: Image.asset('assets/login_eym_logo.png', width: 100),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: const Text(
              'WELCOME',
              style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WODetail extends StatelessWidget {
  final String woId;
  final String priority;
  final String idUser;
  final String latitude;
  final String longitude;
  final String user_type_id;
  final String site_id;

  const WODetail({
    required this.woId,
    required this.priority,
    required this.idUser,
    required this.latitude,
    required this.longitude,
    required this.user_type_id,
    required this.site_id,
  });

  @override
  Widget build(BuildContext context) {
    // Implementa la lógica de la pantalla WODetail aquí
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Order Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Work Order ID: $woId'),
            Text('Priority: $priority'),
            Text('User ID: $idUser'),
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            Text('User Type ID: $user_type_id'),
            Text('Site ID: $site_id'),
          ],
        ),
      ),
    );
  }
}
