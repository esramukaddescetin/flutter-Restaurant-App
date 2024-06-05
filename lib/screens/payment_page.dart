import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PaymentPage(),
  ));
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool isAgreed = false;

  Future<void> _submitPayment() async {
    if (!isAgreed) {
      // Show an error message
      return;
    }

    final paymentData = {
      'cardNumber': cardNumberController.text,
      'expiryDate': expiryDateController.text,
      'cvv': cvvController.text,
      'agreed': isAgreed,
    };

    await FirebaseFirestore.instance.collection('payments').add(paymentData);

    // Show a success message or navigate to another screen
    _showPaymentSuccessMessage();

    // Clear the form
    cardNumberController.clear();
    expiryDateController.clear();
    cvvController.clear();
    setState(() {
      isAgreed = false;
    });
  }

  void _showPaymentSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ödeme başarıyla alındı!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kredi Kartı ile Ödeme', style: TextStyle(color: Colors.white)),
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: cardNumberController,
              style: TextStyle(color: Colors.white70),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CreditCardNumberInputFormatter(),
              ],
              decoration: buildInputDecoration('Kart Numarası', ''),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: expiryDateController,
                    style: TextStyle(color: Colors.white70),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpiryDateInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration('Son Kullanma Tarihi', 'MM/YY'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: cvvController,
                    style: TextStyle(color: Colors.white70),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: buildInputDecoration('CVV', ''),
                  ),
                ),
              ],
            ),
            AgreementBox(
              isAgreed: isAgreed,
              onChanged: (value) {
                setState(() {
                  isAgreed = value ?? false;
                });
              },
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPayment,
                child: Text('Ödeme Yap', style: TextStyle(fontSize: 20, color: Colors.white)),
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

class AgreementBox extends StatelessWidget {
  final bool isAgreed;
  final ValueChanged<bool?>? onChanged;

  AgreementBox({required this.isAgreed, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: isAgreed,
              onChanged: onChanged,
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
