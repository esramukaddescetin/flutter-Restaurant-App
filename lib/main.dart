import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screens/payment_page.dart';
import 'package:restaurant_app/screens/quick_requests.dart';
import 'package:restaurant_app/screens/reservation_page.dart';
import 'package:restaurant_app/screens/signup.dart';
import 'package:restaurant_app/screens/staff_login.dart';
import 'package:restaurant_app/screens/waiter_request.dart';

import 'screens/forgot_password.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/menu_page.dart';
import 'services/provider/auth_provider.dart';
import 'utils/locator.dart';

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(RestaurantApp());
} */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => locator.get<AuthProvider>(),
      )
    ],
    child: const RestaurantApp(),
  ));
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);
  static final db = FirebaseFirestore.instance;

  static Future<void> LoadAll() async {
    await db.collection("users").get().then((event) {
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
