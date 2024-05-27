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
          'Orders',
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
                  builder: (context) => OrderUpdateScreen(tableNumber: tableNumber),
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No orders found'),
              );
            }
            var items = snapshot.data!.docs;
            return ListView.builder(
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  subtitle: Text(
                    'Quantity: ${item['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo[900],
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
