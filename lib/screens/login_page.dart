import 'package:flutter/material.dart';
import 'package:restaurant_app/services/auth_service.dart';

import '../utils/locator.dart';
import '../utils/my_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  Widget inputField(String text, icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: WidgetBackcolor(
              Colors.white60,
              Colors.brown,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/restaurant.png',
                        height: 110,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      inputField('Email', Icons.email, _tEmail),
                      const SizedBox(height: 16),
                      inputField('Password', Icons.lock, _tPassword),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          String email = _tEmail.text.trim();
                          String password = _tPassword.text.trim();

                          // E-posta ve şifre boş mu kontrol edilir
                          if (email.isEmpty || password.isEmpty) {
                            // Eğer boşluk kaldırılmış e-posta ve şifre boşsa, hata mesajı gösterilir
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please enter email and password.'),
                            ));
                          } else {
                            // E-posta ve şifre boş değilse, giriş yapma işlemi başlatılır
                            locator.get<AuthService>().signIn(context, email, password);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.brown[500],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotpasswordPage');
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signPage');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      /*    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Anasayfaya dön',
                          style: TextStyle(color: Colors.brown),
                        ),
                      ),  */
                    ],
                  ),
                ),
              ),
            ),
          ),
          const IconBack(),
        ],
      ),
    );
  }
}
