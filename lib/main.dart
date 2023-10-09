import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pages/WorkOrders.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        //appBar: AppBar(title: const Text(_title)),
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
              'http://srv406820.hstgr.cloud/mainthelpdev/index.php/api/users/Login_post'),
          body: {
            'username': email,
            'password': password,
          });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WorkOrders()),
      );
      print(response.body);
      if (response.body == '"200"') {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkOrders()),
        );
      } else {
        const errorMessage = "Usuario o contraseña incorrectos.";

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error de inicio de sesión"),
              content: const Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  child: const Text("Aceptar"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el AlertDialog.
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 300, 30),
                child: Image.asset('assets/login_eym_logo.png', width: 100)),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(
                  10,
                ),
                child: const Text(
                  'WELCOME',
                  style: TextStyle(
                      color: Color.fromARGB(255, 5, 5, 5),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password',
              ),
            ),
            MaterialButton(
              minWidth: 200.0,
              height: 50,
              onPressed: () {
                login(emailController.text, passwordController.text);
              },
              color: const Color.fromARGB(255, 236, 194, 7),
              child:
                  const Text('LOG IN +', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16), // Agrega espacio vertical de 16 puntos

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('For registration or password recovery.'),
              ],
            ),
            const SizedBox(height: 16), // Agrega espacio vertical de 16 puntos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('contact us 587 4574'),
              ],
            ),
          ],
        ));
  }
}
