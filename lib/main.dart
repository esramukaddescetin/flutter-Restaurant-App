import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/screens/cart.dart/shopping_cart.dart';
import 'package:restaurant_app/screens/menu_page.dart';
import 'package:restaurant_app/screens/payment_page.dart';
import 'package:restaurant_app/screens/quick_requests.dart';
import 'package:restaurant_app/screens/reservation/reservation_page.dart';
import 'package:restaurant_app/screens/signup.dart';
import 'package:restaurant_app/screens/waiter_request.dart';

import 'entry_table_no.dart';
import 'firebase_options.dart';
import 'screens/forgot_password.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/quick_requests.dart';
import 'screens/signup.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => locator.get<AuthProvider>(),
      ),
      // ChangeNotifierProvider<MyProvider>(
      //   create: (context) => MyProvider(),
      // ),
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/homePage': (context) => HomePage(),
        '/loginPage': (context) => LoginPage(),
        '/signPage': (context) => RegisterScreen(),
        '/forgotpasswordPage': (context) => ForgotPasswordScreen(),
        '/tableNumberPage': (context) => TableNumberPage(),
        '/quickrequestsPage': (context) => QuickRequestsPage(tableNumber: 1),
        '/menuPage': (context) => MenuScreen(),
        '/cartPage': (context) => ShoppingCartScreen(tableNumber: 1),
        '/waiterRequestPage': (context) => WaiterRequestPage(),
        '/paymentPage': (context) => PaymentPage(),
        '/reservationPage': (context) => ReservationPage(),
      },
    );
  }
}
