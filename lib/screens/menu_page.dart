import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/cart.dart/shopping_cart.dart';

import '../utils/my_widgets.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MENU',
          style: TextStyle(
            color: Colors.deepPurple[900],
            fontFamily: 'MadimiOne',
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.white38,
          Colors.deepPurple,
        ),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collectionGroup('items').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No menu items available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            var items = snapshot.data!.docs;
            var groupedItems = groupItemsByCategory(items);
            return ListView.builder(
              itemCount: groupedItems.length,
              itemBuilder: (context, index) {
                var category = groupedItems.keys.toList()[index];
                var categoryItems = groupedItems[category]!;
                return ExpansionTile(
                  backgroundColor: Colors.grey[300],
                  title: Text(
                    category,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                      fontFamily: 'MadimiOne',
                    ),
                  ),
                  children: categoryItems.map((item) {
                    return Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients: ${item['ingredients'].join(', ')}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              'Price: ${item['price']} \₺',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.blue[900],
                          ),
                          onPressed: () {
                            addToCart(item);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<String, List<DocumentSnapshot>> groupItemsByCategory(
      List<DocumentSnapshot> items) {
    Map<String, List<DocumentSnapshot>> groupedItems = {};
    items.forEach((item) {
      var category = item.reference.parent.parent!.id;
      if (!groupedItems.containsKey(category)) {
        groupedItems[category] = [];
      }
      groupedItems[category]!.add(item);
    });
    return groupedItems;
  }

  void addToCart(DocumentSnapshot item) async {
    try {
      // ürünü sepette ara
      final QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('name', isEqualTo: item['name'])
          .get();
      if (cartSnapshot.docs.isNotEmpty) {
        // Eğer ürün zaten sepette ise, miktarı artır
        final DocumentSnapshot cartItem = cartSnapshot.docs.first;
        int quantity = cartItem['quantity'] ?? 0;
        await cartItem.reference.update({'quantity': quantity + 1});
      } else {
        // Eğer ürün sepette değilse, yeni bir belge oluştur ve miktarı 1 olarak ayarla
        await FirebaseFirestore.instance.collection('cart').add({
          'name': item['name'],
          'price': item['price'],
          'imageUrl': item['imageUrl'],
          'ingredients': item['ingredients'],
          'quantity': 1,
        });
      }
      _showSuccessDialog();
    } catch (e) {
      print('Error adding to cart: $e');
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    // Başarı ile sepete eklendiğine dair bir dialog gösterilebilir.
  }

  void _showErrorDialog() {
    // Bir hata oluştuğunda kullanıcıya hata mesajı gösterilebilir.
  }
}
