import 'package:flutter/material.dart';
import 'AddNewOrder.dart';
import 'OrderDetail.dart';
import 'package:flutter/material.dart';

class WorkOrders extends StatefulWidget {
  const WorkOrders({Key? key}) : super(key: key);

  @override
  State<WorkOrders> createState() => _WorkOrdersState();
}

class _WorkOrdersState extends State<WorkOrders> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0), // Agrega el padding deseado
      child: Scaffold(
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
        body: ListView(
          padding: const EdgeInsets.all(20), // Agrega el padding deseado

          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: const Text(
                'Work Orders',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(20),
              minWidth: 5,
              height: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewOrder()));
              },
              color: const Color.fromARGB(255, 39, 17, 243),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add, // Cambia a tu icono deseado
                    color: Colors.white,
                  ),
                  SizedBox(width: 10), // Espacio entre el icono y el texto
                  Text(
                    'Add new order',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: const Text(
                '',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            /*MaterialButton(
              padding: const EdgeInsets.all(20),
              minWidth: 5,
              height: 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderDetail()));
              },
              color: const Color.fromARGB(255, 39, 17, 243),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 10), // Espacio entre el icono y el texto
                  Text(
                    'Order Detail View',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            */
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: const Text(
                'ARCHIVE',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            const Card(
              child: ListTile(
                //leading: FlutterLogo(size: 56.0),
                title: Text('444009     Two-line ListTile'),
                subtitle: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            const Card(
              child: ListTile(
                //leading: FlutterLogo(size: 56.0),
                title: Text('878547      Two-line ListTile'),
                subtitle: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            const Card(
              child: ListTile(
                //leading: FlutterLogo(size: 56.0),
                title: Text('939988      Two-line ListTile'),
                subtitle: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
            const Card(
              child: ListTile(
                //leading: FlutterLogo(size: 56.0),
                title: Text('645345       Two-line ListTile'),
                subtitle: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                trailing: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
