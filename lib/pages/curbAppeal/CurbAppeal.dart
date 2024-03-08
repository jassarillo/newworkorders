import 'package:flutter/material.dart';

class CurbAppeal extends StatefulWidget {
  final String idUser;
  final String user_type_id;
  const CurbAppeal({
    Key? key,   
    required this.idUser, 
      required this.user_type_id
  }) : super(key: key);

  @override
  State<CurbAppeal> createState() => _CurbAppealState();
}

class _CurbAppealState extends State<CurbAppeal> {
  TextEditingController searchSiteController = TextEditingController();
  DateTime? selectedDate;
  String selectedCategory = 'Option 1'; // Default value for dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: const Row(
              children: <Widget>[
                // Icon(
                //   Icons.photo,
                //   color: Colors.grey,
                //   size: 30.0,
                // ),
                SizedBox(width: 10),
                Text(
                  'CurbAppeal',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: searchSiteController,
              decoration: InputDecoration(
                labelText: 'Search Site',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : "",
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: <String>['Option 1', 'Option 2']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          MaterialButton(
            padding: const EdgeInsets.all(20),
            minWidth: double.infinity,
            height: 50,
            onPressed: () {
              // Handle save logic
              print('Data saved!');
            },
            color: const Color.fromARGB(255, 39, 17, 243),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
