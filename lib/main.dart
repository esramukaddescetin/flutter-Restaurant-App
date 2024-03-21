import 'package:cloud_firestore/cloud_firestore.dart';
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
  static final db = FirebaseFirestore.instance;

  static Future<void> LoadAll() async {
    await db.collection("menuler").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LoadAll();

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
        '/menuPage': (context) => MenuScreen(),
        '/waiterRequestPage': (context) => WaiterRequestPage(),
        '/paymentPage': (context) => PaymentPage(),
        '/reservationPage': (context) => ReservationPage(),
      },
    );
  }
}
