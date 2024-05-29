import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PastOrdersScreen extends StatelessWidget {
  final int tableNumber;

  PastOrdersScreen({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Geçmiş Siparişler',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontFamily: 'PermanentMarker',
          ),
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('completed_orders')
              .where('tableNumber', isEqualTo: tableNumber)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Geçmiş siparişiniz bulunmamaktadır.'),
              );
            }

            var orders = snapshot.data!.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                var data = order.data() as Map<String, dynamic>;

                return ListTile(
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
                    data['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  subtitle: Text(
                    'Price: ${data['price']} \₺, Quantity: ${data['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo[900],
                    ),
                  ),
                  trailing: Text(
                    data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate().toString()
                        : 'N/A',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
