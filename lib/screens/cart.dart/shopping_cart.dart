import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/cart.dart/order_list.dart';
import 'package:restaurant_app/screens/cart.dart/past_orders.dart';

import '../../utils/my_widgets.dart';

class ShoppingCartScreen extends StatefulWidget {
  final int tableNumber;

  ShoppingCartScreen({required this.tableNumber});

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sepet',
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
            onPressed: () async {
              var cartItems =
                  await FirebaseFirestore.instance.collection('cart').get();
              if (cartItems.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sepete öğe ekleyin!'),
                  ),
                );
              } else {
                await sendOrdersToFirestore(widget.tableNumber);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Siparişleri garsona gönder!'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          Colors.teal,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  var orderItems = await FirebaseFirestore.instance
                      .collection('orders')
                      .where('tableNumber', isEqualTo: widget.tableNumber)
                      .get();
                  if (orderItems.docs.isEmpty) {
                    showNoCurrentOrderDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderListScreen(tableNumber: widget.tableNumber),
                      ),
                    );
                  }
                },
                child: const Text('Siparişime Git',
                    style: TextStyle(color: Colors.teal)),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('cart').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Sepet boş!'),
                    );
                  }
                  var items = snapshot.data!.docs;
                  totalPrice = items.fold(0.0, (sum, item) {
                    return sum + (item['price'] * item['quantity']);
                  });
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            var item = items[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
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
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Fiyat: ${item['price']} \₺',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            decreaseQuantity(item);
                                          },
                                        ),
                                        Text(
                                          item['quantity'].toString(),
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            increaseQuantity(item);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deleteItem(item);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Toplam Fiyat:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                            Text(
                              '$totalPrice \₺',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void increaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1;
    await item.reference.update({'quantity': quantity + 1});
  }

  void decreaseQuantity(DocumentSnapshot item) async {
    int quantity = item['quantity'] ?? 1;
    if (quantity > 1) {
      await item.reference.update({'quantity': quantity - 1});
    } else {
      await item.reference.delete();
    }
  }

  void deleteItem(DocumentSnapshot item) async {
    await item.reference.delete();
  }

  Future<void> sendOrdersToFirestore(int tableNumber) async {
    final cartItems = await FirebaseFirestore.instance.collection('cart').get();
    for (var item in cartItems.docs) {
      await FirebaseFirestore.instance.collection('orders').add({
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'imageUrl': item['imageUrl'],
        'tableNumber': tableNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    await FirebaseFirestore.instance.collection('cart').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  void showNoCurrentOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Güncel siparişiniz yok'),
          content: const Text(
              'Şu anda güncel bir siparişiniz bulunmamaktadır. Geçmiş siparişlerinizi görmek ister misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PastOrdersScreen(tableNumber: widget.tableNumber),
                  ),
                );
              },
              child: const Text('Geçmiş Siparişlerimi Gör'),
            ),
          ],
        );
      },
    );
  }
}
