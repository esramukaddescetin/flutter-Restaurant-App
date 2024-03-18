import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/payment_page.dart';
import 'package:restaurant_app/quick_requests.dart';
import 'package:restaurant_app/reservation_page.dart';
import 'package:restaurant_app/signup.dart';
import 'package:restaurant_app/staff_login.dart';
import 'package:restaurant_app/waiter_request.dart';

import 'firebase_options.dart';
import 'forgot_password.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => QuickRequestsPage(),
        '/homePage': (context) => HomePage(),
        '/loginPage': (context) => LoginPage(),
        '/signPage': (context) => RegisterScreen(),
        '/forgotpasswordPage': (context) => ForgotPasswordScreen(),
        '/staffloginPage': (context) => StaffLoginPage(),
        '/quickrequestsPage': (context) => QuickRequestsPage(),
        '/menuPage': (context) => MenuScreen(),
        '/waiterRequestPage': (context) => WaiterRequestPage(),
        '/paymentPage': (context) => PaymentPage(),
        '/reservationPage': (context) => ReservationPage(),
      },
    );
  }
}
