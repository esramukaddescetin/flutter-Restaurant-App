import 'package:flutter/material.dart';
import 'package:restaurant_app/my_widgets.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PaymentPage(),
  ));
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kredi Kartı ile Ödeme',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown[400], // AppBar rengi
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kart Bilgileri',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Metin rengi
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Kart Numarası',
                labelStyle: TextStyle(color: Colors.white), // Metin rengi
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white), // Çerçeve rengi
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Son Kullanma Tarihi',
                      labelStyle: TextStyle(color: Colors.white), // Metin rengi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white), // Çerçeve rengi
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: Colors.white), // Metin rengi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white), // Çerçeve rengi
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: AgreementBox(),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ödeme işlemi yap
                },
                child: Text(
                  'Ödeme Yap',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.brown[300], // Buton arka plan rengi
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgreementBox extends StatefulWidget {
  @override
  State<AgreementBox> createState() => _AgreementBoxState();
}

class _AgreementBoxState extends State<AgreementBox> {
  bool isAgreed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
        ),
        SizedBox(height: 20),
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isAgreed,
              onChanged: (value) {
                setState(() {
                  isAgreed = value ?? false;
                });
              },
            ),
            Text(
              'Sözleşmeleri okudum ve kabul ediyorum',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
