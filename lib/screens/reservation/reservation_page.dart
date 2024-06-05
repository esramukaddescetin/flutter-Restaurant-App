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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedTable;
  List<String> _tables = [];

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('tables').get();
    final tables = querySnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      _tables = tables;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final available = await _isDateAvailable(pickedDate);
      if (available) {
        setState(() {
          _selectedDate = pickedDate;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected date is fully booked")),
        );
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked.hour >= 9 && picked.hour <= 23) {
      final available = await _isTimeAvailable(_selectedDate!, picked);
      if (available) {
        setState(() {
          _selectedTime = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected time is fully booked")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time between 09:00 and 23:00")),
      );
    }
  }

  Future<bool> _isDateAvailable(DateTime date) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .doc('${date.year}-${date.month}-${date.day}')
        .get();
    if (!docSnapshot.exists) {
      return true;
    }
    final data = docSnapshot.data()!;
    return data.length < 24; // Assuming max 24 reservations per day
  }

  Future<bool> _isTimeAvailable(DateTime date, TimeOfDay time) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .doc('${date.year}-${date.month}-${date.day}')
        .get();
    if (!docSnapshot.exists) {
      return true;
    }
    final data = docSnapshot.data()!;
    return !data.containsKey('${time.hour}:${time.minute}');
  }

  Future<void> _makeReservation() async {
    if (_selectedDate == null || _selectedTime == null || _phoneController.text.isEmpty || _nameController.text.isEmpty || _selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }
    final dateKey = '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    final timeKey = '${_selectedTime!.hour}:${_selectedTime!.minute}';

    final reservationData = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'time': timeKey,
      'table': _selectedTable,
    };

    final docRef = FirebaseFirestore.instance.collection('reservations').doc(dateKey);
    await docRef.set({timeKey: reservationData}, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reservation made successfully")),
    );
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
                controller: _nameController,
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
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedTable,
                items: _tables
                    .map((table) => DropdownMenuItem<String>(
                          value: table,
                          child: Text('Masa $table'),
                        ))
                    .toList(),
                onChanged: (value) async {
                  final available = await _isTableAvailable(_selectedDate, _selectedTime, value);
                  if (available) {
                    setState(() {
                      _selectedTable = value;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Selected table is fully booked at the selected time")),
                    );
                  }
                },
                decoration: buildInputDecoration('Masa Numarası', ''),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _makeReservation,
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

  Future<bool> _isTableAvailable(DateTime? date, TimeOfDay? time, String? table) async {
    if (date == null || time == null || table == null) {
      return false;
    }

    final dateKey = '${date.year}-${date.month}-${date.day}';
    final timeKey = '${time.hour}:${time.minute}';
    final docSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .doc(dateKey)
        .get();

    if (!docSnapshot.exists) {
      return true;
    }

    final data = docSnapshot.data()!;
    if (data.containsKey(timeKey)) {
      final reservations = data[timeKey] as Map<String, dynamic>;
      return reservations['table'] != table;
    }

    return true;
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReservationPage(),
  ));
}
