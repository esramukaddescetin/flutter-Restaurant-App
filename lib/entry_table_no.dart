import 'package:flutter/material.dart';

class TableNumberPage extends StatefulWidget {
  @override
  _TableNumberPageState createState() => _TableNumberPageState();
}

class _TableNumberPageState extends State<TableNumberPage> {
  TextEditingController _tableNumberController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masa Numarası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // Sola yaslanması için
          children: [
            Text(
              'Masa numaranızı giriniz',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left, // Sola yaslanması için
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _tableNumberController,
              keyboardType: TextInputType.number,
              maxLength: 2, // Maksimum uzunluk 2 (0-20 arası)
              decoration: InputDecoration(
                labelText: 'Masa Numarası (0-20)',
                border: OutlineInputBorder(),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Masa numarası bilgisini al
                int tableNumber =
                    int.tryParse(_tableNumberController.text) ?? 0;

                // Girilen numara 20'den büyükse hata mesajı göster
                if (tableNumber > 20) {
                  setState(() {
                    _errorMessage = 'Masa numarası 20\'den büyük olamaz';
                  });
                } else {
                  // Alınan masa numarasını kullanarak ilgili işlemi gerçekleştir
                  // Örneğin, bir sonraki ekrana geçiş yapabilir veya veritabanına kaydedebilirsiniz
                  setState(() {
                    _errorMessage = '';
                    //masa müsaitse yönlendir!!
                    Navigator.pushNamed(context, '/quickrequestsPage');
                  });
                }
              },
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Belleği temizle
    _tableNumberController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: TableNumberPage(),
  ));
}
