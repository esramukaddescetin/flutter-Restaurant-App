import 'package:flutter/material.dart';

import '../utils/my_widgets.dart';

class QuickRequestsPage extends StatefulWidget {
  @override
  State<QuickRequestsPage> createState() => _QuickRequestsPageState();
}

class _QuickRequestsPageState extends State<QuickRequestsPage> {
  Color menuButtonColor = Colors.blue;
  Color callWaiterButtonColor = Colors.green;
  Color writeRequestButtonColor = Colors.orange;
  Color newServiceButtonColor = Colors.red;
  Color paymentButtonColor = Colors.purple;
  Color creditCardButtonColor = Colors.teal;
  Color reservationButtonColor = Colors.blueGrey;

  String buttonCallWaiterText = "Garson Çağır";
  String buttonNewService = "Masama Yeni Servis";
  String buttonPayment = "Masada Ödeme";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Container(
            decoration: WidgetBackcolor(
              Colors.white,
              Colors.brown,
            ),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildQuickRequestButton(
                      Icons.restaurant_menu, 'Menü', menuButtonColor, () {
                    Navigator.pushNamed(context, '/menuPage');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.person, buttonCallWaiterText, callWaiterButtonColor,
                          () {
                        setState(() {
                          callWaiterButtonColor = Colors.black;
                          buttonCallWaiterText = 'Garson Çağırıldı';
                          print('Garson Çağırıldı');
                        });
                      }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.event_note, 'Garsona Talep Yaz',
                      writeRequestButtonColor, () {
                        setState(() {
                          writeRequestButtonColor = Colors.orange;
                          print('Garsona Talep Yaz');
                        });
                        Navigator.pushNamed(context, '/waiterRequestPage');
                      }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.restaurant, buttonNewService, newServiceButtonColor,
                          () {
                        setState(() {
                          buttonNewService = "Servis Talebi Alındı";
                          newServiceButtonColor = Colors.black;
                          print('Masaya Yeni Servis Talebi Alındı');
                        });
                      }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.payment, buttonPayment, paymentButtonColor, () {
                    setState(() {
                      paymentButtonColor = Colors.black;
                      buttonPayment = "Masada Ödeme Talebi Alındı";
                    });
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.credit_card,
                      'Kredi Kartı ile Ödeme', creditCardButtonColor, () {
                        setState(() {
                          creditCardButtonColor = Colors.teal;
                          print('Kredi Kartı ile Ödeme Yapıldı');
                        });
                        Navigator.pushNamed(context, '/paymentPage');
                      }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.calendar_today,
                      'Rezervasyon Yap', reservationButtonColor, () {
                        setState(() {
                          reservationButtonColor = Colors.blueGrey;
                          print('Rezervasyon Yapıldı');
                        });
                        Navigator.pushNamed(context, '/reservationPage');
                      }),
                ],
              ),
            ),
          ),
          IconBack(),
        ],
      ),
    );
  }

  Widget buildQuickRequestButton(
      IconData icon, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        padding:
        MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuickRequestsPage(),
  ));
}