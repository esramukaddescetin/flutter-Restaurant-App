import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                title: Text(item['name']),
                subtitle: Text('Price: ${item['price']} \$'),
                // İsterseniz buraya diğer öğe özelliklerini ekleyebilirsiniz
              );
            },
          );
        },
      ),
    );
  }
}
