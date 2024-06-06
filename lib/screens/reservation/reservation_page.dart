import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../phone_input_formatter.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedTable;
  List<String> _tables = [];
  List<TimeOfDay> _availableTimes = [];

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    final tablesSnapshot =
        await FirebaseFirestore.instance.collection('tables').get();
    setState(() {
      _tables = tablesSnapshot.docs
          .map((doc) => doc['tableNumber'].toString())
          .toList();
    });
  }

  Future<List<DateTime>> _getReservedTimes(DateTime selectedDate) async {
    final reservationsSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
        .where('dateTime',
            isLessThan:
                Timestamp.fromDate(selectedDate.add(const Duration(days: 1))))
        .get();

    final reservedTimes = reservationsSnapshot.docs.map((doc) {
      final reservationDateTime = (doc['dateTime'] as Timestamp).toDate();
      return DateTime(
        reservationDateTime.year,
        reservationDateTime.month,
        reservationDateTime.day,
        reservationDateTime.hour,
        reservationDateTime.minute,
      );
    }).toList();

    return reservedTimes;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final reservedTimes = await _getReservedTimes(pickedDate);

      setState(() {
        _selectedDate = pickedDate;
        _availableTimes = _generateAvailableTimes(reservedTimes);
        _selectedTime = null; // Reset selected time when date changes
      });
    }
  }

  List<TimeOfDay> _generateAvailableTimes(List<DateTime> reservedTimes) {
    final allTimes =
        List.generate(24, (index) => TimeOfDay(hour: index, minute: 0));
    final availableTimes = <TimeOfDay>[];

    for (final time in allTimes) {
      final dateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
          _selectedDate!.day, time.hour, time.minute);
      if (!reservedTimes.any((reservedTime) => dateTime == reservedTime)) {
        availableTimes.add(time);
      }
    }

    return availableTimes;
  }

  Future<void> _makeReservation() async {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _phoneController.text.isEmpty ||
        _selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final isAvailable = await _checkAvailability(dateTime, _selectedTable!);

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Seçilen masa bu zaman aralığı için zaten ayrılmış")),
      );
      return;
    }

    final reservationData = {
      'phone': _phoneController.text,
      'dateTime': Timestamp.fromDate(dateTime),
      'table': _selectedTable,
      'name': _nameController.text,
    };

    await FirebaseFirestore.instance
        .collection('reservations')
        .add(reservationData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rezervasyon başarıyla yapıldı")),
    );

    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _phoneController.clear();
      _nameController.clear();
      _selectedTable = null;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<bool> _checkAvailability(DateTime dateTime, String table) async {
    final reservationsSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('table', isEqualTo: table)
        .where('dateTime',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(dateTime.subtract(const Duration(hours: 1))))
        .where('dateTime',
            isLessThanOrEqualTo:
                Timestamp.fromDate(dateTime.add(const Duration(hours: 1))))
        .get();

    return reservationsSnapshot.docs.isEmpty;
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                  decoration: const InputDecoration(
                    labelText: 'İsim',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
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
                  decoration: const InputDecoration(
                    labelText: 'Telefon Numarası',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    labelText: _selectedDate == null
                        ? 'Tarih seçiniz'
                        : 'Seçilen tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
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
                DropdownButtonFormField<TimeOfDay>(
                  value: _selectedTime,
                  items: _availableTimes.map((time) {
                    return DropdownMenuItem(
                      value: time,
                      child: Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.brown),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Saat seçiniz',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.brown),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedTable,
                  items: _tables.map((table) {
                    return DropdownMenuItem(
                      value: table,
                      child: Text(
                        'Masa $table',
                        style: const TextStyle(color: Colors.brown),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTable = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Masa seçiniz',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _makeReservation,
                  child: const Text(
                    'Rezervasyon Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    backgroundColor: Colors.brown[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
