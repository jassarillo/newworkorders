import 'dart:convert';
import 'WODetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RedirectTo extends StatefulWidget {
  final String idUser;
  final String user_type_id;
  final String woId;
  const RedirectTo(
      {required this.idUser,
      required this.user_type_id,
      required this.woId,
      Key? key})
      : super(key: key);

  @override
  State<RedirectTo> createState() => _RedirectToState();
}

class _RedirectToState extends State<RedirectTo> {
  @override
  void initState() {
    super.initState();
    fetchWorkOrderDetails(widget.woId, widget.idUser);
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
    );
  }

  void fetchWorkOrderDetails(String woId, String idUser) async {
    try {
      final response = await http.get(Uri.parse(
          'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_get/$woId/1/1'));
      //print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> workOrders = json.decode(response.body);

        if (workOrders.isNotEmpty) {
          final Map<String, dynamic> workOrder = workOrders.first;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WODetail(
                woId: workOrder['wo_id'],
                priority: workOrder['priority'],
                idUser: widget.idUser, // Corrección aquí
                latitude: workOrder['latitude'],
                longitude: workOrder['length'],
                user_type_id: widget.user_type_id,
                site_id: workOrder['site_id'],
              ),
            ),
          );
        }
      } else {
        // Manejar el error de la solicitud, si es necesario
      }
    } catch (e) {
      // Manejar excepciones, si es necesario
    }
  }
}
