import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QuickRequestsPage extends StatefulWidget {
  final int tableNumber;

  const QuickRequestsPage({Key? key, required this.tableNumber})
      : super(key: key);

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

  bool isCallWaiterEnabled = true;
  bool isNewServiceEnabled = true;
  bool isPaymentEnabled = true;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .where('message', isEqualTo: 'Garson Çağırıldı')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        bool isChecked = data['checked'] ?? false;
        setState(() {
          isCallWaiterEnabled = isChecked;
          buttonCallWaiterText =
              isChecked ? 'Garson Çağır' : 'Garson Çağırıldı';
          callWaiterButtonColor = isChecked ? Colors.green : Colors.black;
        });
      }
    });

    // Yeni servis talebi bildirimlerini dinleyin
    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .where('message', isEqualTo: 'Yeni servis talebi alındı')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        bool isChecked = data['checked'] ?? false;
        setState(() {
          isNewServiceEnabled = isChecked;
          buttonNewService =
              isChecked ? 'Masama Yeni Servis' : 'Servis Talebi Alındı';
          newServiceButtonColor = isChecked ? Colors.red : Colors.black;
        });
      }
    });

    // Ödeme talebi bildirimlerini dinleyin
    FirebaseFirestore.instance
        .collection('notifications')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .where('message', isEqualTo: 'Ödeme talebi alındı')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        bool isChecked = data['checked'] ?? false;
        setState(() {
          isPaymentEnabled = isChecked;
          buttonPayment =
              isChecked ? 'Masada Ödeme' : 'Masada Ödeme Talebi Alındı';
          paymentButtonColor = isChecked ? Colors.purple : Colors.black;
        });
      }
    });

    final InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings('app_icon'),
            iOS: DarwinInitializationSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                colors: [Colors.brown[100]!, Colors.brown[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildQuickRequestButton(
                      Icons.restaurant_menu, 'Menü', menuButtonColor, () {
                    Navigator.pushNamed(context, '/menuPage',
                        arguments: widget.tableNumber);
                  }),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.person,
                      buttonCallWaiterText,
                      callWaiterButtonColor,
                      isCallWaiterEnabled
                          ? () {
                              setState(() {
                                callWaiterButtonColor = Colors.black;
                                sendNotificationToFirebase(
                                    widget.tableNumber, 'Garson Çağırıldı');
                              });
                            }
                          : null),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(Icons.event_note, 'Garsona Talep Yaz',
                      writeRequestButtonColor, () {
                    Navigator.pushNamed(context, '/waiterRequestPage');
                  }),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.restaurant,
                      buttonNewService,
                      newServiceButtonColor,
                      isNewServiceEnabled
                          ? () {
                              setState(() {
                                newServiceButtonColor = Colors.black;
                              });
                              sendNotificationToFirebase(widget.tableNumber,
                                  'Yeni servis talebi alındı');
                            }
                          : null),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.payment,
                      buttonPayment,
                      paymentButtonColor,
                      isPaymentEnabled
                          ? () {
                              setState(() {
                                paymentButtonColor = Colors.black;
                              });
                              sendNotificationToFirebase(
                                  widget.tableNumber, 'Ödeme talebi alındı');
                            }
                          : null),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(Icons.credit_card,
                      'Kredi Kartı ile Ödeme', creditCardButtonColor, () {
                    // Kredi kartı ile ödeme butonuna basıldığında
                    Navigator.pushNamed(context, '/paymentPage');
                  }),
                  const SizedBox(height: 10),
                  buildQuickRequestButton(Icons.calendar_today,
                      'Rezervasyon Yap', reservationButtonColor, () {
                    // Rezervasyon yap butonuna basıldığında
                    Navigator.pushNamed(context, '/reservationPage');
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickRequestButton(
      IconData icon, String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(20)),
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
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

// Firebase'e bildirim gönderme fonksiyonu
  void sendNotificationToFirebase(
      int tableNumber, String notificationMessage) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'tableNumber': tableNumber,
        'message': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'checked': false,
      });
      print('Bildirim Firebase\'e başarıyla gönderildi.');
    } catch (e) {
      print('Bildirim gönderirken bir hata oluştu: $e');
    }
  }
}

void main() {
  int tableNumber = 1;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuickRequestsPage(tableNumber: tableNumber),
  ));
}
