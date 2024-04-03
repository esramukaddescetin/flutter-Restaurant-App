import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

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
        backgroundColor: Colors.brown[400],
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
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: TextStyle(color: Colors.white70),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CreditCardNumberInputFormatter(),
              ],
              decoration: buildInputDecoration(
                'Kart Numarası',
                '',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white70),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpiryDateInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(
                      'Son Kullanma Tarihi',
                      'MM/YY',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: buildInputDecoration(
                      'CVV',
                      '',
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
                  backgroundColor: Colors.brown[300],
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

class CreditCardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }
    List<String> result = [];
    for (int i = 0; i < newText.length; i += 4) {
      result.add(newText.substring(i, i + 4));
    }
    return TextEditingValue(
      text: result.join(' '),
      selection: TextSelection.collapsed(offset: result.join(' ').length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }
    if (newText.length >= 3 && !newText.contains('/')) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
