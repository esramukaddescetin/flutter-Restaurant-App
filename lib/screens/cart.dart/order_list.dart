import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/cart.dart/order_update.dart';

import '../../utils/my_widgets.dart';

class OrderListScreen extends StatelessWidget {
  final int tableNumber;

  OrderListScreen({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Siparişler',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Colors.teal[100],
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.blueGrey[900],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderUpdateScreen(tableNumber: tableNumber),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          Colors.teal,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('orders')
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
                child: Text('Sipariş bulunamadı.'),
              );
            }
            var items = snapshot.data!.docs;
            double totalPrice = 0.0;
            for (var item in items) {
              int quantity = item['quantity'] ?? 1;
              double price = item['price'] ?? 0.0;
              totalPrice += quantity * price;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Toplam Fiyat: ${totalPrice.toStringAsFixed(2)} \₺',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return ListTile(
                        leading: Image.network(
                          item['imageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        subtitle: Text(
                          'Miktar: ${item['quantity']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[900],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
