import 'dart:convert';
import 'pages/WorkOrders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        //appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String latitude = 'Latitud: -';
  String longitude = 'Longitud: -';
  void login(String email, password) async {
    try {
      //print('hola mundo!');
      http.Response response = await http.post(
          Uri.parse(
              'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/users/Login_post'),
          body: {
            'username': email,
            'password': password,
          });
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print('type... ' + responseData['estatus']);
      if (responseData['estatus'] == "200") {
        // ignore: use_build_context_synchronously
        final String idUser = responseData['idUser'];
        final String user_type_id = responseData['user_type_id'];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkOrders(idUser: idUser, user_type_id: user_type_id)),
        );
      } else if (responseData['estatus'] == "2020") {
        const errorMessage = "User or password failed.";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Access Error"),
              content: const Text(errorMessage),
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
      print("Error: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    //getLocation();
    requestLocationPermission();
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
      //print(position.latitude);
      //print(position.longitude);
      //double distanceInMeters = await Geolocator.distanceBetween(
      //position.latitude, position.longitude, 19.426314, -98.877709);
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
                child: Image.asset('assets/login_eym_logo.png', width: 100)),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(
                  10,
                ),
                child: const Text(
                  'WELCOME',
                  style: TextStyle(
                      color: Color.fromARGB(255, 5, 5, 5),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
              ),
            ),
            MaterialButton(
              minWidth: 200.0,
              height: 50,
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              color: const Color.fromARGB(255, 236, 194, 7),
              child:
                  const Text('LOG IN', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16), // Agrega espacio vertical de 16 puntos

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('For registration or password recovery.'),
              ],
            ),
            const SizedBox(height: 16), // Agrega espacio vertical de 16 puntos
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('contact us 587 4574'),
              ],
            ),
          ],
        ));
  }
}
