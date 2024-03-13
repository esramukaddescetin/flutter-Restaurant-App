import 'package:flutter/material.dart';

import 'my_widgets.dart';

class QuickRequestsPage extends StatefulWidget {
  @override
  State<QuickRequestsPage> createState() => _QuickRequestsPageState();
}

class _QuickRequestsPageState extends State<QuickRequestsPage> {
  late Color buttonColor;
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
                      Icons.restaurant_menu, 'Menü', Colors.blue, () {
                    Navigator.pushNamed(context, '/menuPage');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.person, 'Garson Çağır', Colors.green, () {
                    // Garson çağırıldı mesajı dön ekrana
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                    Icons.event_note,
                    'Garsona Talep Yaz',
                    Colors.orange,
                    () {
                      Navigator.pushNamed(context, '/waiterRequestPage');
                    },
                  ),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                    Icons.restaurant,
                    'Masama Yeni Servis',
                    Colors.red,
                    () {
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            // Butona basıldığında rengi değiştir
                            return Colors
                                .brown; // Örneğin, buton basıldığında rengi koyu kahverengi olsun
                          } else {
                            // Basılmadığında veya varsayılan durumda rengi
                            return Colors.red; // Verilen renk olsun
                          }
                        },
                      );
                      // Masaya yeni servis talebiniz alındı mesajı dön
                    },
                  ),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                    Icons.payment,
                    'Masada Ödeme',
                    Colors.purple,
                    () {
                      //Masada Ödeme talebiniz alındı mesajını ekrana yazdır
                    },
                  ),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                    Icons.credit_card,
                    'Kredi Kartı ile Ödeme',
                    Colors.teal,
                    () {},
                  ),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                    Icons.calendar_today,
                    'Rezervasyon Yap',
                    Colors.blueGrey,
                    () {
                      setState(() {
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white);
                        Text('Rezervazyon Yapıldı');
                      });
                    },
                  ),
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
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(20),
        ),
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
    // title: 'Hızlı Talepler',
    home: QuickRequestsPage(),
  ));
}
