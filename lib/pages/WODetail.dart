import 'dart:convert';
import 'CheckIn.dart';
import 'Comments.dart';
import 'WorkOrders.dart';
import 'TroubleShooting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'subPantallasCheck/Assigness.dart';
import 'subPantallasCheck/Quotation.dart';
import 'package:Help_Maintenance/pages/subPantallasCheck/OperativeCost.dart';

class WODetail extends StatefulWidget {
  final String woId;
  final String priority;
  final String idUser;
  final String latitude;
  final String longitude;
  final String user_type_id;
  final String site_id;

  const WODetail({
    Key? key,
    required this.woId,
    required this.priority,
    required this.idUser,
    required this.latitude,
    required this.longitude,
    required this.user_type_id,
    required this.site_id,
  }) : super(key: key);

  @override
  State<WODetail> createState() => _WODetailState();
}

Color getColorForPriority(String priority) {
  switch (priority.toLowerCase()) {
    case 'low':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'high':
      return Colors.red;
    case 'critical':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

Future<Map<String, dynamic>> fetchWorkOrderDetails(
    String woId, String idUser, String user_type_id) async {
  final url = Uri.parse(
      'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Wo_get/$woId/$user_type_id/$idUser');
  final response = await http.get(url);
  //print('$woId');
  //print(response.body);
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      //print(jsonResponse[0]);
      return jsonResponse[0];
    }
  }

  return {};
}

class _WODetailState extends State<WODetail> {
  String? idUser;

  @override
  void initState() {
    super.initState();
    idUser = widget.idUser;
  }

  @override
  Widget build(BuildContext context) {
    // final userType = int.tryParse(widget.user_type_id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WorkOrders(
                  idUser: widget.idUser,
                  user_type_id: widget.user_type_id,
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchWorkOrderDetails(
            widget.woId, widget.idUser, widget.user_type_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final workOrderDetails = snapshot.data;
            final woId = workOrderDetails?['wo_id'];
            final descriptionStatus = workOrderDetails?['description'];
            final priority = workOrderDetails?['priority'];
            final unit = workOrderDetails?['unit'];
            final assetName = workOrderDetails?['asset_name'];
            final woDescription = workOrderDetails?['wo_description'];
            final brand_id = workOrderDetails?['brand_id'];
            final wostatus_id = workOrderDetails?['wostatus_id'];
            final vAssigness = workOrderDetails?['vAssigness'];
            final vQuotations = workOrderDetails?['vQuotations'];
            // print('wostatus_id> ' + wostatus_id + ' A ' + vAssigness);
            return ListView(
              padding: const EdgeInsets.all(5),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Work Order Number ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              woId,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              descriptionStatus,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
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
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: getColorForPriority(priority),
                              ),
                              child: Text(
                                priority,
                                style: const TextStyle(color: Colors.white),
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
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Unit',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize:
                              10, // Puedes ajustar el tamaño del label según tus preferencias
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Asset',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize:
                              10, // Puedes ajustar el tamaño del label según tus preferencias
                        ),
                      ),
                      Text(
                        assetName,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Problem',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize:
                              12, // Puedes ajustar el tamaño del label según tus preferencias
                        ),
                      ),
                      Text(
                        woDescription,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Alinea al "top left"
                          children: <Widget>[
                            const Text(
                              'Due Time',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '4 Days',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Created',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '12/122023',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end, // Alinea al "top right"
                          children: <Widget>[
                            const Text(
                              'Closed',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 5, 5),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '12/122023',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (widget.user_type_id == '3' || widget.user_type_id == '7')
                  MaterialButton(
                    padding: const EdgeInsets.all(5),
                    minWidth: 5,
                    height: 50,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckIn(
                                  woId: woId,
                                  idUser: this.idUser!,
                                  latitudeA: widget.latitude,
                                  longitudeA: widget.longitude,
                                  site_id: widget.site_id,
                                  user_type_id: widget.user_type_id,
                                  priority: widget.priority)));
                    },
                    color: const Color.fromARGB(255, 39, 17, 243),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'CHECK IN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Comments(woId: woId),
                      ),
                    );
                  },
                  child: const Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                      title: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 2,
                        children: <Widget>[
                          Text(
                            'Photos',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(''),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                    ),
                  ),
                ),
                if(widget.user_type_id != '3' && widget.user_type_id != '7')
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Comments(woId: woId),
                      ),
                    );
                  },
                  child: const Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.comment,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                      title: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 2,
                        children: <Widget>[
                          Text(
                            'Comments',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(''),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                    ),
                  ),
                ),
                if ((wostatus_id == '3' ||
                        wostatus_id == '5' ||
                        wostatus_id == '6' ||
                        wostatus_id == '7' ||
                        wostatus_id == '8' ||
                        ((wostatus_id == '9' ||
                                wostatus_id == '10' ||
                                wostatus_id == '11' ||
                                wostatus_id == '12') &&
                            vQuotations == 1)) &&
                    (widget.user_type_id != '3' && widget.user_type_id != '7'))
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Quotation(
                              woId: widget.woId,
                              idUser: widget.idUser,
                              user_type_id: widget.user_type_id),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
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
                        title: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 2,
                          children: <Widget>[
                            Text(
                              'Quotations',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text('Reported quotations'),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 124, 122, 122),
                        ),
                      ),
                    ),
                  ),
                if ((wostatus_id == '4' ||
                        ((wostatus_id == '9' ||
                                wostatus_id == '10' ||
                                wostatus_id == '11' ||
                                wostatus_id == '12') &&
                            vAssigness == 1)) &&
                    (widget.user_type_id != '3' && widget.user_type_id != '7'))
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OperativeCost(
                            woId: widget.woId,
                            idUser: widget.idUser,
                            user_type_id: widget.user_type_id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
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
                        title: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 2,
                          children: <Widget>[
                            Text(
                              'Operative Cost',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(''),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 124, 122, 122),
                        ),
                      ),
                    ),
                  ),
                if ((wostatus_id == '3' ||
                        wostatus_id == '4' ||
                        ((wostatus_id == '9' ||
                                wostatus_id == '10' ||
                                wostatus_id == '11' ||
                                wostatus_id == '12') &&
                            vAssigness == 1)) &&
                    (widget.user_type_id != '3' && widget.user_type_id != '7'))
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Assigness(
                              woId: woId,
                              idUser: widget.idUser,
                              user_type_id: widget.user_type_id),
                        ),
                      );
                    },
                    child: const Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 124, 122, 122),
                        ),
                        title: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 2,
                          children: <Widget>[
                            Text(
                              'Assigness',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(''),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 124, 122, 122),
                        ),
                      ),
                    ),
                  ),
                  if(widget.user_type_id != '3' && widget.user_type_id != '7')
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TroubleShooting(
                          insertId: woId.toString(),
                          idUser: widget.idUser,
                          user_type_id: widget.user_type_id,
                          brand_id: brand_id.toString(),
                        ),
                      ),
                    );
                  },
                  child: const Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.list,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                      title: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 2,
                        children: <Widget>[
                          Text(
                            'TroubleShoting',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(''),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 124, 122, 122),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            // Mostrar un indicador de carga o manejar el caso de error aquí.
            return const Center(
              child: Text('No se encontraron datos.'),
            );
          }
        },
      ),
    );
  }
}
