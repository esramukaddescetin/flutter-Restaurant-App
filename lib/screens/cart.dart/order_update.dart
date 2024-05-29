import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/menu_page.dart';
import '../../utils/my_widgets.dart';

class OrderUpdateScreen extends StatefulWidget {
  final int tableNumber;

  const OrderUpdateScreen({required this.tableNumber});

  @override
  _OrderUpdateScreenState createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  int totalQuantity = 0;
  double totalPrice = 0.0;
  bool isLoading = false; // Yükleme durumu için değişken

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
      body: Stack(
        children: [
          Container(
            decoration: WidgetBackcolor(
              Colors.white38,
              Colors.teal,
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('tableNumber', isEqualTo: widget.tableNumber)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No orders found'),
                  );
                }
 
                var items = snapshot.data!.docs;
                totalQuantity = 0;
                totalPrice = 0.0;

                for (var item in items) {
                  int quantity = (item['quantity'] ?? 1) as int;
                  double price = (item['price'] ?? 0.0).toDouble();
                  totalQuantity += quantity;
                  totalPrice += quantity * price;
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Quantity: $totalQuantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Total Price: ${totalPrice.toStringAsFixed(2)} \₺',
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
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  'Price: ${(item['price'] ?? 0.0).toString()} \₺',
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
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    decreaseQuantity(item);
                                  },
                                ),
                                Text((item['quantity'] ?? 1)
                                    .toString()), // Miktarı göster
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    increaseQuantity(item);
                                  },
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteOrder(item);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              saveChanges();
                            },
                            child: const Text('Save Changes'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blueGrey[900],
                              backgroundColor:
                                  Colors.teal[200], // Butonun yazı rengi
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              clearCart();
                            },
                            child: const Text('Clear Cart'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blueGrey[900],
                              backgroundColor:
                                  Colors.red[200], // Butonun yazı rengi
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void increaseQuantity(DocumentSnapshot item) async {
    int quantity = (item['quantity'] ?? 1) as int; // Varsayılan değer 1
    var newQuantity = quantity + 1;
    await item.reference.update({'quantity': newQuantity});
    setState(() {});
  }

  void decreaseQuantity(DocumentSnapshot item) async {
    int quantity = (item['quantity'] ?? 1) as int; // Varsayılan değer 1
    if (quantity > 1) {
      var newQuantity = quantity - 1;
      await item.reference.update({'quantity': newQuantity});
    } else {
      // Eğer miktar 1'den küçükse, ürünü sil
      await item.reference.delete();
    }
    setState(() {});
  }

  void deleteOrder(DocumentSnapshot item) async {
    await item.reference.delete();
    setState(() {});
  }

  void clearCart() async {
    setState(() {
      isLoading = true;
    });

    // Belirli masanın tüm siparişlerini silme
    var orders = await FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .get();

    for (var order in orders.docs) {
      await order.reference.delete();
    }

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart cleared successfully!'),
      ),
    );
  }

  void saveChanges() async {
    setState(() {
      isLoading = true;
    });

    // Değişiklikleri kaydetme işlemleri burada yapılabilir
    // Bu örnekte veritabanına zaten güncellenen veriler kaydedildiği için bir işlem yapılmıyor

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
      ),
    );
  }
}
