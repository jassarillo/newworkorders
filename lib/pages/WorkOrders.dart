import 'package:flutter/material.dart';
import 'AddNewOrder.dart';
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
              icon: const Icon(Icons.call),
            ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewOrder()));
              },
              color: Color.fromARGB(255, 39, 17, 243),
              child: const Text(
                'Add new order',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Card(child: ListTile(title: Text('456144'))),
            const Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
            ),
          ),
          ],
          
        ),
        
      ),
    );
  }
}
