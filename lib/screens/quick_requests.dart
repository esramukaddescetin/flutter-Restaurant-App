import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/my_widgets.dart';

class QuickRequestsPage extends StatefulWidget {
  final int tableNumber;

  const QuickRequestsPage({Key? key, required this.tableNumber})
      : super(key: key);

  @override
  State<QuickRequestsPage> createState() => _QuickRequestsPageState();
}

class _QuickRequestsPageState extends State<QuickRequestsPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
  void initState() {
    super.initState();
    // Bildirim ayarlarını yapılandır ve başlat
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('app_icon'),
            iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

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
                    // Menü butonuna basıldığında
                    Navigator.pushNamed(context, '/menuPage', arguments: widget.tableNumber);
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.person, buttonCallWaiterText, callWaiterButtonColor,
                      () {
                    // Garson çağır butonuna basıldığında
                    setState(() {
                      callWaiterButtonColor = Colors.black;
                      buttonCallWaiterText = 'Garson Çağırıldı';
                      print('Garson Çağırıldı');
                    });
                    sendNotification('Garson Çağırıldı',
                        'Masa ${widget.tableNumber} için garson çağrıldı');
                    sendNotificationToFirebase(
                        widget.tableNumber, 'Garson çağırıldı');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.event_note, 'Garsona Talep Yaz',
                      writeRequestButtonColor, () {
                    // Garsona talep yaz butonuna basıldığında
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
                    // Yeni servis talebi butonuna basıldığında
                    setState(() {
                      buttonNewService = "Servis Talebi Alındı";
                      newServiceButtonColor = Colors.black;
                      print('Masaya Yeni Servis Talebi Alındı');
                    });
                    sendNotification('Yeni Servis Talebi Alındı',
                        'Masa ${widget.tableNumber} için yeni servis talebi alındı');
                    sendNotificationToFirebase(
                        widget.tableNumber, 'Yeni servis talebi alındı');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(
                      Icons.payment, buttonPayment, paymentButtonColor, () {
                    // Ödeme talebi butonuna basıldığında
                    setState(() {
                      paymentButtonColor = Colors.black;
                      buttonPayment = "Masada Ödeme Talebi Alındı";
                    });
                    sendNotification('Ödeme Talebi Alındı',
                        'Masa ${widget.tableNumber} için ödeme talebi alındı');
                    sendNotificationToFirebase(
                        widget.tableNumber, 'Ödeme talebi alındı');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.credit_card,
                      'Kredi Kartı ile Ödeme', creditCardButtonColor, () {
                    // Kredi kartı ile ödeme butonuna basıldığında
                    setState(() {
                      creditCardButtonColor = Colors.teal;
                      print('Kredi Kartı ile Ödeme Yapıldı');
                    });
                    Navigator.pushNamed(context, '/paymentPage');
                  }),
                  SizedBox(height: 10),
                  buildQuickRequestButton(Icons.calendar_today,
                      'Rezervasyon Yap', reservationButtonColor, () {
                    // Rezervasyon yap butonuna basıldığında
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

  // Bildirim gönderme fonksiyonu
  Future<void> sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Bildirim ID'si
      title, // Bildirim başlığı
      body, // Bildirim içeriği
      platformChannelSpecifics,
      payload: 'item x', // İsteğe bağlı payload
    );
  }

  // Firebase'e bildirim gönderme fonksiyonu
  void sendNotificationToFirebase(int tableNumber, String notificationMessage) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'tableNumber': tableNumber,
        'message': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
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
    home: QuickRequestsPage(
      tableNumber: tableNumber
    ),
  ));
}
