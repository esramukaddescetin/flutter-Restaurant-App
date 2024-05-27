import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/my_widgets.dart';

class OrderUpdateScreen extends StatelessWidget {
  final int tableNumber;

  const OrderUpdateScreen({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Orders',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Colors.teal[100],
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
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Price: ${item['price']} \₺',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          decreaseQuantity(item);
                        },
                      ),
                      Text(item['quantity'].toString()), // Miktarı göster
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          increaseQuantity(item);
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItem(item);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void increaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1; // Varsayılan değer 1
    await item.reference.update({'quantity': quantity + 1});
  }

  void decreaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1; // Varsayılan değer 1
    if (quantity > 1) {
      await item.reference.update({'quantity': quantity - 1});
    } else {
      // Eğer miktar 1'den küçükse, ürünü sil
      await item.reference.delete();
    }
  }

  void deleteItem(DocumentSnapshot item) async {
    await item.reference.delete();
  }
}
