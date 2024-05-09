import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/screens/cart.dart/shopping_cart.dart';


class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartScreen()), // ShoppingCartScreen'a yönlendirme yapıldı
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collectionGroup('items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No menu items available'),
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
                title: Text(category),
                children: categoryItems.map((item) {
                  return ListTile(
                    leading: Image.network(
                      item['imageUrl'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${item['price']} \$'),
                        Text('Ingredients: ${item['ingredients'].join(', ')}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        addToCart(item);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<DocumentSnapshot>> groupItemsByCategory(List<DocumentSnapshot> items) {
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
      await FirebaseFirestore.instance.collection('cart').add({
        'name': item['name'],
        'price': item['price'],
        'imageUrl': item['imageUrl'],
        'ingredients': item['ingredients'],
      });
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
