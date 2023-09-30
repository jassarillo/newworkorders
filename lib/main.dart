import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'Sample App';
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        //appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
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
  try{
    http.Response response = await http.post(Uri.parse('https://reqres.in/api/login'),
    body:{
      'email': email, 
      'password':password,
    }
    );
    if(response.statusCode == 200){
      print(response.body);
      print('Acceso correcto!!!');
    }else{
      print('fail login');
    }
  } catch (e) {
    print(e.toString());
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
                child: Image.asset('assets/login_eym_logo.png',width:100)
                ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10, ),
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
              onPressed: () {
                //forgot password screen
                
              },
              child: const Text('Forgot Password',),
            ),
            // Container(
            //     height: 50,
            //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //     child: ElevatedButton(
            //     style: TextButton.styleFrom(foregroundColor: Colors.black),
            
            //       child: const Text('LOG IN'),
            //       onPressed: () {
            //         login(emailController.text, passwordController.text);
            //         //print(emailController.text);
            //         //print(passwordController.text);
            //         //print('Hola Mundo!');
            //       },
            //     )
            // ),
            MaterialButton(
                  minWidth: 200.0,
                  height: 50,
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  },
                  color: const Color.fromARGB(255, 236, 194, 7),
                  child: const Text('LOG IN',
                  style: TextStyle(color: Colors.black)),
                   
                ),
                
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ));
  }
  
}
//  Widget build(BuildContext context) {
//   // ...
//   return const DecoratedBox(
//     decoration: BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage('assets/2.png'),
//       ),
//     ),
//   );
//   // ...
// }