import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/my_widgets.dart';

class ShoppingCartScreen extends StatelessWidget {
  final int tableNumber;

  ShoppingCartScreen({required this.tableNumber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontFamily: 'PermanentMarker',
          ),
        ),
        backgroundColor: Colors.teal[100],
        actions: [
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.blueGrey[900],
            ),
            onPressed: () {
              sendOrdersToFirestore(tableNumber);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Orders sent to the waiter!'),
              ));
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
          stream: FirebaseFirestore.instance.collection('cart').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Shopping cart is empty'),
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

  void sendOrdersToFirestore(int tableNumber) async {
    final cartItems = await FirebaseFirestore.instance.collection('cart').get();
    for (var item in cartItems.docs) {
      await FirebaseFirestore.instance.collection('orders').add({
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'imageUrl': item['imageUrl'],
        'tableNumber': item['tableNumber'], // Siparişin orijinal masası
        'originalTableNumber':
            tableNumber, // Siparişin hangi masaya ait olduğunu belirt
      });
    }
    await FirebaseFirestore.instance.collection('cart').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
