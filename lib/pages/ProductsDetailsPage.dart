import 'package:flutter/material.dart';
class ProductsDetailsPage extends StatefulWidget {
  const ProductsDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPageState();
}

class _ProductsDetailsPageState extends State<ProductsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product detail page'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Opción 1'),
                  value: 'opcion1',
                ),
                PopupMenuItem(
                  child: Text('Opción 2'),
                  value: 'opcion2',
                ),
                // Agrega más opciones según tus necesidades
              ];
            },
            onSelected: (value) {
              // Maneja la selección del menú aquí
              if (value == 'opcion1') {
                // Ejecuta una acción para la opción 1
              } else if (value == 'opcion2') {
                // Ejecuta una acción para la opción 2
              }
            },
          ),
        ],
      ),
      body: const Center(),
    );
  }
}


