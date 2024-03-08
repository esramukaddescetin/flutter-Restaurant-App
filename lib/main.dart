import 'package:flutter/material.dart';
import 'package:restaurant_app/quick_requests.dart';
import 'package:restaurant_app/signup.dart';
import 'package:restaurant_app/staff_login.dart';

import 'forgot_password.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'menu_page.dart';

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/homePage': (context) => HomePage(),
        '/loginPage': (context) => LoginPage(),
        '/signPage': (context) => RegisterScreen(),
        '/forgotpasswordPage': (context) => ForgotPasswordScreen(),
        '/staffloginPage': (context) => StaffLoginPage(),
        '/quickrequestsPage': (context) => QuickRequestsPage(),
        '/menuPage': (context) => MenuPage(),
      },
    );
  }
}
