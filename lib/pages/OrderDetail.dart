import 'package:flutter/material.dart';
import 'AddNewOrder.dart';
class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
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
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: const Text(
                'Work order number',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: const Text(
                '458144',
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
                '',
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 5, 5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
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
              subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
              trailing: Icon(Icons.more_vert),
            ),
          ),          
          ],
          
        ),
        
      ),
    );
  }
}
