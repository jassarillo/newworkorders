import 'Comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


class WODetail extends StatefulWidget {
  final String woId;
  final String priority;
  const WODetail({
    Key? key,
    required this.woId,
    required this.priority, // Agregar el valor inicial aquí
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
      return Colors
          .grey; // Color por defecto si no coincide con ninguno de los valores anteriores
  }
}

class _WODetailState extends State<WODetail> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Alinea los elementos a la izquierda y derecha
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
                        fontSize: 10,
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
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .end, // Alinea los elementos a la derecha
                    children: <Widget>[
                      Text(
                        'Status',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'open',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .end, // Alinea los elementos a la derecha
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
                          color: getColorForPriority('high'),
                        ),
                        child: const Text(
                          'high',
                          style: TextStyle(color: Colors.white),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Unit',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                    fontSize:
                        10, // Puedes ajustar el tamaño del label según tus preferencias
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
                    fontSize:
                        10, // Puedes ajustar el tamaño del label según tus preferencias
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
                    fontSize:
                        12, // Puedes ajustar el tamaño del label según tus preferencias
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
          Row(
            mainAxisAlignment: MainAxisAlignment
                .center, // Alinea los elementos horizontalmente al centro
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(14),
                child: const Column(
                  children: <Widget>[
                    Text(
                      'Due Time',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize:
                            10, // Puedes ajustar el tamaño del label según tus preferencias
                      ),
                    ),
                    Text(
                      '4581447',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(14),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Created',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize:
                            12, // Puedes ajustar el tamaño del label según tus preferencias
                      ),
                    ),
                    Text(
                      '26/10/2023',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(14),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Closed',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize:
                            10, // Puedes ajustar el tamaño del label según tus preferencias
                      ),
                    ),
                    Text(
                      '26/10/2023',
                      style: TextStyle(
                        color: Color.fromARGB(255, 5, 5, 5),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MaterialButton(
  padding: const EdgeInsets.all(5),
  minWidth: 5,
  height: 50,
  onPressed: () {},
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
  
Card(
  child: const ListTile(
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
    subtitle: Text('woDescription ccdcd'),
    trailing: Icon(
      Icons.arrow_forward,
      color: Color.fromARGB(255, 124, 122, 122),
    ),
  ),
),
   MaterialButton(
     padding: const EdgeInsets.all(20),
     minWidth: 5,
     height: 50,
     onPressed: () {
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => const Comments()));
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
