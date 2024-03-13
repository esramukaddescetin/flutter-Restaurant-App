import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/my_widgets.dart';
//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
//import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class ReservationPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rezervasyon Yap',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[400],
      ),
      body: Container(
        decoration: WidgetBackcolor(Colors.brown, Colors.white70),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rezervasyon Detayları',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  'İsim',
                  '',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  PhoneInputFormatter(),
                ],
                style: TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  'Telefon Numarası',
                  '',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white70),

                decoration: buildInputDecoration(
                  'Tarih',
                  '',
                ),
                readOnly: true, // Kullanıcıdan giriş yapılmamasını sağlar
                onTap: () {
                  // Tarih seçme işlemi yapılabilir
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white70),

                decoration: buildInputDecoration(
                  'Saat',
                  '',
                ),
                readOnly: true, // Kullanıcıdan giriş yapılmamasını sağlar
                onTap: () {
                  // Saat seçme işlemi yapılabilir
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Rezervasyon yapma işlemi gerçekleştirilir
                },
                child: Text(
                  'Rezervasyon Yap',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  backgroundColor: Colors.brown[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReservationPage(),
  ));
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }
    if (newText.length == 0) {
      return TextEditingValue();
    }
    StringBuffer newTextBuffer = StringBuffer();
    newTextBuffer.write('(');
    newTextBuffer.write(newText.substring(0, 3));
    newTextBuffer.write(') ');
    if (newText.length > 3) {
      newTextBuffer.write(newText.substring(3, 6));
      newTextBuffer.write('-');
    }
    if (newText.length > 6) {
      newTextBuffer.write(newText.substring(6, 8));
      newTextBuffer.write('-');
    }
    if (newText.length > 8) {
      newTextBuffer.write(newText.substring(8, 10));
    }
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: newTextBuffer.length),
    );
  }
}
