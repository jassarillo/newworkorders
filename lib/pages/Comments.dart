import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Comments extends StatefulWidget {
  final String woId;
  const Comments({required this.woId, Key? key}) : super(key: key);

  //Comments({required this.woId});
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String woId = '';
  String priority = '';
  String description = '';

  Color getColorForPriority(String priority) {
    if (priority == 'high') {
      return Colors.red;
    } else if (priority == 'medium') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkOrderDetailsMessages(widget.woId);
  }
 
  Future<void> fetchWorkOrderDetailsMessages(String woId) async {
    final url = Uri.parse(
        'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/workorders/Comments_get/$woId');
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        final woData = jsonResponse[0][0];
        // Obtén los valores necesarios del JSON
        final woId = woData['wo_id'] as String; // Acceder como String
        final priority = woData['priority'] as String;
        final description = woData['description'] as String;
        // Actualiza los valores de las variables de estado
        setState(() {
          this.woId = woId;
          this.priority = priority;
          this.description = description;
        });
        print(this.priority);
      }
    }
  }

//Selecting multiple images from Gallery
  List<XFile>? imageFileList = [];
  void selectImages() async {}

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
     body: Center(
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
                     Text(
                       'Work Order Number',
                       style: TextStyle(
                         color: Color.fromARGB(255, 5, 5, 5),
                         fontWeight: FontWeight.w500,
                         fontSize: 10,
                       ),
                     ),
                     Text(
                       this.woId, // Usar la variable woId aquí
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
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
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
                         description, // Usar la variable description aquí
                         style: TextStyle(color: Colors.blue),
                       ),
                     ],
                   ),
                 ),
               ),
               Expanded(
                 child: Container(
                   margin: EdgeInsets.all(10),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: <Widget>[
                       Text(
                         'Priority',
                         style: TextStyle(
                           color: Color.fromARGB(255, 5, 5, 5),
                           fontWeight: FontWeight.w500,
                           fontSize: 16,
                         ),
                       ),
                       Container(
                         padding: EdgeInsets.all(3),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: getColorForPriority(priority),
                         ),
                         child: Text(
                           priority, // Usar la variable priority aquí
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
             padding: const EdgeInsets.all(10),
             margin: const EdgeInsets.all(10),
             child: Row(
               children: <Widget>[
                 Icon(
                   Icons
                       .comment, // Icono de comentario, puedes cambiarlo por el que desees
                   color: Colors.blue, // Color del icono
                   size: 30.0, // Tamaño del icono
                 ),
                 const SizedBox(
                     width: 10), // Espacio entre el icono y el texto
                 Text(
                   'COMMENTS',
                   style: TextStyle(
                     color: Colors.black,
                     fontWeight: FontWeight.w500,
                     fontSize: 30,
                   ),
                 ),
               ],
             ),
           ),
           
         ],
       ),
     ),
   );
 }
}
