import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PastOrdersScreen extends StatelessWidget {
  final int tableNumber;

  PastOrdersScreen({required this.tableNumber});

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geçmiş Siparişler - ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink[800],
                fontFamily: 'PermanentMarker',
              ),
            ),
            Text(
              'Masa $tableNumber',
              style: TextStyle(
                fontSize: 18,
                color: Colors.pink[800],
                fontFamily: 'PermanentMarker',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal[100],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white38, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('completed_orders')
              .where('tableNumber', isEqualTo: tableNumber)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Henüz geçmiş sipariş yok.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var order = snapshot.data!.docs[index];
                  var data = order.data() as Map<String, dynamic>;
                  int quantity = data['quantity'] ?? 1;
                  String timestamp = formatTimestamp(data['timestamp']);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      leading: data['imageUrl'] != null
                          ? Image.network(
                              data['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                              child: Icon(Icons.image, color: Colors.white),
                            ),
                      title: Text(
                        data['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                            'Fiyat: ${data['price']} \₺, Miktar: $quantity',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            timestamp,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
