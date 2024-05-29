import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/my_widgets.dart';

class WaiterRequestPage extends StatelessWidget {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _requestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        final int tableNumber = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Garsona Talep Yaz',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.white60,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Başlık',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Başlık girin',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Talep',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextFormField(
                controller: _requestController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Talebinizi girin',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  sendWaiterRequest(
                    context,
                    _titleController.text,
                    _requestController.text,
                    tableNumber, // tableNumber'ı burada ekleyin
                  );
                },
                child: const Text(
                  'Garsona Gönder',
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendWaiterRequest(
    BuildContext context,
    String title,
    String request,
    int tableNumber, // tableNumber'ı parametre olarak alın
  ) {
    // Veritabanına talebi ekle
    FirebaseFirestore.instance.collection('waiter_requests').add({
      'tableNumber': tableNumber,
      'title': title,
      'request': request,
      'timestamp': Timestamp.now(),
    }).then((value) {
      // Talep başarıyla gönderildiğinde kullanıcıya geribildirim ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Talebiniz gönderildi!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }).catchError((error) {
      // Hata durumunda kullanıcıya geribildirim ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Talep gönderirken bir hata oluştu. Lütfen tekrar deneyin.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
