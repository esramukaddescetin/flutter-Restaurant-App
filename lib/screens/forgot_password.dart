import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _tEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan
          Container(
            decoration: WidgetBackcolor(
              Colors.white60,
              Colors.brown.shade900,
            ),
          ),

          // Geri gitme butonu
          IconBack(),

          // Şifremi Unuttum Formu
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

                  // Şifremi Unuttum Formu
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _tEmail,
                          decoration: InputDecoration(
                            labelText: 'E-posta',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 12,
                            backgroundColor: Colors.brown[200],
                          ),
                          onPressed: () {
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(email: _tEmail.text)
                                .then((value) => Navigator.of(context).pop());
                          },
                          child: Text(
                            'Şifremi Sıfırla',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForgotPasswordScreen(),
  ));
}
