import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
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
          var cartItems = snapshot.data!.docs;
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = cartItems[index];
              var itemName = cartItem['name'];
              return ShoppingCartItem(itemName: itemName);
            },
          );
        },
      ),
    );
  }
}

class ShoppingCartItem extends StatefulWidget {
  final String itemName;

  ShoppingCartItem({required this.itemName});

  @override
  State<ShoppingCartItem> createState() => _ShoppingCartItemState();
}

class _ShoppingCartItemState extends State<ShoppingCartItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('cart')
          .where('name', isEqualTo: widget.itemName)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        var itemCountMap = <String, int>{};
        for (var item in snapshot.data!.docs) {
          var itemName = item['name'];
          if (!itemCountMap.containsKey(itemName)) {
            itemCountMap[itemName] = 1;
          } else {
            itemCountMap[itemName] = (itemCountMap[itemName] ?? 0) + 1;
          }
        }
        var itemCount = itemCountMap[widget.itemName] ?? 0;
        return ListTile(
          leading: Image.network(
            snapshot.data!.docs[0]['imageUrl'],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          title: Text(widget.itemName),
          subtitle: Text('Price: ${snapshot.data!.docs[0]['price']} \$'),
          trailing: Text('Quantity: $itemCount'),
        );
      },
    );
  }
}flutter pub get
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart Demo',
      home: ShoppingCartScreen(),
    );
  }
}
