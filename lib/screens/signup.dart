import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/services/auth_service.dart';
import 'package:restaurant_app/utils/locator.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

import '../phone_input_formatter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kayıt Sayfası',
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40), // Köşe yarıçapı
                    child: Image.asset(
                      'assets/images/restaurant.png',
                      width: 200,
                      height: 120,
                      fit: BoxFit.cover, // Resmin boyutlandırma şekli
                    ),
                  ),
                  SizedBox(height: 20),
                  inputField(
                    _tName,
                    Icons.person,
                    'Ad',
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
                    'Soyad',
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tEmail,
                    Icons.email,
                    'Email',
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _tPhone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                      PhoneInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                      ),
                      hintText: 'Telefon Numarası',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  inputField(
                    _tPassword,
                    Icons.lock,
                    'Şifre',
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
                            // phone: int.parse(_tPhone.text),
                            phone: _tPhone.text,
                            password: _tPassword.text);
                        //   Navigator.pushNamed(context, '/tableNumberPage');
                      },
                      child: Text('KAYIT OL',
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
                      Text("Zaten hesabınız var mı?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Giriş'),
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
