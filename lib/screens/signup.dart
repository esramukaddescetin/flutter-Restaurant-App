import 'package:flutter/material.dart';
import 'package:restaurant_app/services/provider/auth_service.dart';
import 'package:restaurant_app/utils/locator.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration Page',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hoverColor: Colors.deepPurpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final _tName = TextEditingController();
  final _tLastName = TextEditingController();
  final _tEmail = TextEditingController();
  final _tPhone = TextEditingController();
  final _tPassword = TextEditingController();
  Widget inputField(TextEditingController controller, icon, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: text,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.grey,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/restaurant_logo.jpg',
                    width: 150,
                  ),
                  SizedBox(height: 20),
                  inputField(
                    _tName,
                    Icons.person,
                    'First Name',
                  ),
                  /*   TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'First Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
*/
                  SizedBox(height: 10),
                  inputField(
                    _tLastName,
                    Icons.person,
                    'Last Name',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tEmail,
                    Icons.email,
                    'Email',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tPhone,
                    Icons.phone,
                    'Phone Number',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tPassword,
                    Icons.lock,
                    'Password',
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        locator.get<AuthService>().signUp(context,
                            name: _tName.text,
                            lastname: _tLastName.text,
                            email: _tEmail.text,
                            phone: int.parse(_tPhone.text),
                            password: _tPassword.text);
                        //   Navigator.pushNamed(context, '/quickrequestsPage');
                      },
                      child: Text('SIGN UP',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        //primary: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.brown[500],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
