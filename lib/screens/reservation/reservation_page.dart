import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/phone_input_formatter.dart';
import 'package:restaurant_app/utils/my_widgets.dart';

class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _nameController = TextEditingController();
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
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    setState(() {
      _selectedTime = picked;
    });
  }
}

  Future<void> _makeReservation() async {
    if (_selectedDate != null && _selectedTime != null) {
      try {
        CollectionReference reservations =
            FirebaseFirestore.instance.collection('reservations');

        await reservations.add({
          'name': _nameController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'date': _selectedDate!,
          'time': _selectedTime!,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Rezervasyon Yapıldı'),
              content: Text('Rezervasyonunuz başarıyla yapıldı!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );

        _nameController.clear();
        _phoneController.clear();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('Rezervasyon yapılırken bir hata oluştu.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
        print('Rezervasyon yapılırken hata oluştu: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bilgi Eksik'),
            content: Text('Lütfen tarih ve saat seçiniz.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
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
              const Text(
                'Rezervasyon Detayları',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  'İsim',
                  '',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  PhoneInputFormatter(),
                ],
                style: const TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  'Telefon Numarası',
                  '',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
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
                child: const Text('Tarih Seç',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Colors.white70),
                decoration: buildInputDecoration(
                  _selectedTime != null
                      ? 'Saat Seç'
                      : 'Seçilen Saat: ${_selectedTime!.hour}:${_selectedTime!.minute}',
                  '',
                ),
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: const Text('Saat Seç',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _makeReservation,
                child: const Text(
                  'Rezervasyon Yap',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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
