import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/my_widgets.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/homePage';
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 110,
                backgroundColor: Colors.brown[300],
                backgroundImage:
                    const AssetImage('assets/images/restaurant_logo.jpg'),
              ),
              Text(
                'PİGOME RESTORAN',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.brown[900],
                  fontFamily: 'Yellowtail',
                ),
              ),
              const Center(
                child: Text(
                  '"Her Yemeğin Arkasında Bir Gülümseme Var"',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'MadimiOne',
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 18,
                child: const Divider(color: Colors.brown),
              ),
              const CardEntry(
                icon: Icons.mail,
                text: 'pigome@restaurant.com',
              ),
              const SizedBox(
                height: 6,
              ),
              const CardEntry(icon: Icons.phone, text: '0370 654 96 52'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                child: const ButtonEntry(giris: 'Müşteri Girişi'),
              ),
              TextButton(
                onPressed: () async {
                  final result = await authService.signInAnonymous();
                  if (result != null) {
                    Navigator.pushNamed(context, '/tableNumberPage');
                  } else {
                    print("hata ile karşılaşıldu");
                  }
                },
                child: const ButtonEntry(giris: 'Üyeliksiz Devam Et'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
