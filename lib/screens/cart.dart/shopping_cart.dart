import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: StreamBuilder(
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
                      child: Text(item['name']),
                    ),
                    SizedBox(width: 20),
                    Text('Price: ${item['price']} \$'),
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
    );
  }

//artirir
  void increaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1; // Varsayılan değer 1
    await item.reference.update({'quantity': quantity + 1});
  }

//azaltir
  void decreaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1; // Varsayılan değer 1
    if (quantity > 1) {
      await item.reference.update({'quantity': quantity - 1});
    } else {
      // Eğer miktar 1'den küçükse, ürünü sil
      await item.reference.delete();
    }
  }
}
