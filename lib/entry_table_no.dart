import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/cart.dart/shopping_cart.dart';
import 'package:restaurant_app/screens/quick_requests.dart';
import 'package:restaurant_app/utils/my_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableNumberPage extends StatefulWidget {
  @override
  _TableNumberPageState createState() => _TableNumberPageState();
}

class _TableNumberPageState extends State<TableNumberPage> {
  TextEditingController _tableNumberController = TextEditingController();
  String _errorMessage = '';
  bool _isButtonEnabled =
      false; 

  @override
  void initState() {
    super.initState();
    _tableNumberController.addListener(() {
      final isValidTableNumber =
          int.tryParse(_tableNumberController.text) != null;
      setState(() {
        _isButtonEnabled = isValidTableNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Masa Numarası',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.white60,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masa numaranızı giriniz',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _tableNumberController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  // labelText: 'Masa Numarası (0-20)',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  counterStyle: TextStyle(color: Colors.brown[300]),
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                  errorStyle: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed:
                    _isButtonEnabled // Butonun etkinliğini takip eden değişkeni kullanın
                        ? () async {
                            int tableNumber =
                                int.tryParse(_tableNumberController.text) ?? 0;
                            // Firestore sorgusu
                            bool isTableExist =
                                await checkTableExist(tableNumber);
                            if (!isTableExist) {
                              setState(() {
                                _errorMessage = 'Masa numarası mevcut değil';
                              });
                            } else {
                              setState(() {
                                _errorMessage = '';
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuickRequestsPage(
                                      tableNumber: tableNumber,
                                    ),
                                  ),
                                );
                              });
                            }
                          }
                        : null, // Buton etkin değilse onPressed: null
                // Butonun etkin olması durumunda metin
                child: const Text(
                  'Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                // Butonun stilini belirleyen kısım
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 45.0,
                  ),
                  backgroundColor: Colors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  // Firestore sorgusu için fonksiyon
  Future<bool> checkTableExist(int tableNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tables')
        .where('tableNumber', isEqualTo: tableNumber)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}

void main() {
  runApp(MaterialApp(
    home: TableNumberPage(),
  ));
}
