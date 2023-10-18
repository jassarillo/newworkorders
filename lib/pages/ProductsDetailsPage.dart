import 'package:flutter/material.dart';
class ProductsDetailsPage extends StatefulWidget {

  final String woId;
  const ProductsDetailsPage({
    Key? key,
  required this.woId,
  }) : super(key: key);

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  @override
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
     body: ListView(
       padding: const EdgeInsets.all(5),
       children: <Widget>[
      
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Work Order Number',
              style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontWeight: FontWeight.w500,
                fontSize: 10, // Puedes ajustar el tamaño del label según tus preferencias
              ),
            ),
            Text(
              '4581447',
              style: TextStyle(
                color: Color.fromARGB(255, 5, 5, 5),
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      Container(
   alignment: Alignment.topLeft,
   padding: const EdgeInsets.all(5),
   margin: const EdgeInsets.all(5),
   child: const Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Text(
         'Unit',
         style: TextStyle(
           color: Color.fromARGB(255, 5, 5, 5),
           fontWeight: FontWeight.w500,
           fontSize: 10, // Puedes ajustar el tamaño del label según tus preferencias
         ),
       ),
       Text(
         'Integer omare aliquam',
         style: TextStyle(
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
   padding: const EdgeInsets.all(5),
   margin: const EdgeInsets.all(5),
   child: const Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Text(
         'Asset',
         style: TextStyle(
           color: Color.fromARGB(255, 5, 5, 5),
           fontWeight: FontWeight.w500,
           fontSize: 10, // Puedes ajustar el tamaño del label según tus preferencias
         ),
       ),
       Text(
         'Donec egestas massa',
         style: TextStyle(
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
   padding: const EdgeInsets.all(5),
   margin: const EdgeInsets.all(5),
   child: const Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Text(
         'Problem',
         style: TextStyle(
           color: Color.fromARGB(255, 5, 5, 5),
           fontWeight: FontWeight.w500,
           fontSize: 10, // Puedes ajustar el tamaño del label según tus preferencias
         ),
       ),
       Text(
         'Lorem ipsum es el texto que se usa habitualmente en diseño gráfico en demostraciones de tipografías.',
         style: TextStyle(
           color: Color.fromARGB(255, 5, 5, 5),
           fontWeight: FontWeight.w500,
           fontSize: 15,
         ),
       ),
     ],
   ),
 ),


         MaterialButton(
           padding: const EdgeInsets.all(5),
           minWidth: 5,
           height: 50,
           onPressed: () {
           },
           color: const Color.fromARGB(255, 39, 17, 243),
           child: const Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 Icons.add,
                 color: Colors.white,
               ),
               SizedBox(width: 10),
               Text(
                 'Add new order',
                 style: TextStyle(color: Colors.white),
               ),
             ],
           ),
         ),
         
       ],
     ),
   );
 }
}


