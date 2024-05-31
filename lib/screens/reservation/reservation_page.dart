//import 'package:calendar_date_picker2/calendar_date_picker2.dart' as dp;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/phone_input_formatter.dart';
import 'package:restaurant_app/utils/my_widgets.dart';


//import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _phoneController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

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
                  _selectedDate == null
                      ? 'Tarih Seçilmedi'
                      : 'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  '',
                ),
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Tarih Seç', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  _selectedTime == null
                      ? 'Saat Seç'
                      : 'Seçilen Saat: ${_selectedTime!.hour}:${_selectedTime!.minute}',
                  '',
                ),
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Saat Seç', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                ),
              ),
              SizedBox(height: 30),
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