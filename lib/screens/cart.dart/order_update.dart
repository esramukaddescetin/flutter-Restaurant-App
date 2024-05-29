import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderUpdateScreen extends StatefulWidget {
  final int tableNumber;

  const OrderUpdateScreen({required this.tableNumber});

  @override
  _OrderUpdateScreenState createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  int totalQuantity = 0;
  double totalPrice = 0.0;
  bool isLoading = false; // Loading state variable
  List<Map<String, dynamic>> _modifiedOrders = []; // List to track modified orders

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white38, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                                Text((item['quantity'] ?? 1).toString()),
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
                              backgroundColor: Colors.teal[200],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              clearCart();
                            },
                            child: const Text('Clear Cart'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blueGrey[900],
                              backgroundColor: Colors.red[200],
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

  // Function to increase quantity
  void increaseQuantity(DocumentSnapshot item) {
    int quantity = (item['quantity'] ?? 1) as int;
    var newQuantity = quantity + 1;
    item.reference.update({'quantity': newQuantity});
    setState(() {
      // Track modified orders locally
      if (!_modifiedOrders.contains(item)) {
        _modifiedOrders.add({
          'id': item.id,
          'quantity': newQuantity,
        });
      }
    });
  }

  // Function to decrease quantity
  void decreaseQuantity(DocumentSnapshot item) {
    int quantity = (item['quantity'] ?? 1) as int;
    if (quantity > 1) {
      var newQuantity = quantity - 1;
      item.reference.update({'quantity': newQuantity});
      setState(() {
        // Track modified orders locally
        if (!_modifiedOrders.contains(item)) {
          _modifiedOrders.add({
            'id': item.id,
            'quantity': newQuantity,
          });
        }
      });
    } else {
      // If quantity is 1 or less, delete the order
      item.reference.delete();
    }
  }

  // Function to delete an order
  void deleteOrder(DocumentSnapshot item) {
    item.reference.delete();
  }

  // Function to clear the cart
  void clearCart() async {
    setState(() {
      isLoading = true;
    });

    // Get all orders for the specific table
    var orders = await FirebaseFirestore.instance
        .collection('orders')
        .where('tableNumber', isEqualTo: widget.tableNumber)
        .get();

    // Delete each order
    for (var order in orders.docs) {
      order.reference.delete();
    }

    setState(() {
      isLoading = false;
    });

    // Show a snackbar indicating successful clearance
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart cleared successfully!'),
      ),
    );
  }

  // Function to save changes to the database
  void saveChanges() async {
    setState(() {
      isLoading = true;
    });

    // Iterate through local modifications and update Firestore
    for (var order in _modifiedOrders) {
      await FirebaseFirestore.instance.collection('orders').doc(order['id']).update({
        'quantity': order['quantity'],
      });
    }

    // Clear local modifications after saving changes
    _modifiedOrders.clear();

    setState(() {
      isLoading = false;
    });
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changes saved successfully!'),
      ),
    );
  }
}


