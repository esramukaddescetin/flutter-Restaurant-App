import 'package:flutter/material.dart';

void main() {
  runApp(MenuPage());
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenuPage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menü'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CategoryCard(
              category: 'Çorba',
              items: [
                MenuItem(
                  name: 'Mercimek Çorbası',
                  ingredients: 'Kırmızı mercimek, soğan, havuç, su, tuz',
                  price: '10 TL',
                  imageUrl: 'https://example.com/mercimek_corbasi.jpg',
                ),
                MenuItem(
                  name: 'Domates Çorbası',
                  ingredients: 'Domates, soğan, un, tuz, biber',
                  price: '12 TL',
                  imageUrl: 'https://example.com/domates_corbasi.jpg',
                ),
                // Diğer çorba örnekleri...
              ],
            ),
            CategoryCard(
              category: 'Ana Yemek',
              items: [
                MenuItem(
                  name: 'Izgara Tavuk',
                  ingredients: 'Tavuk, baharatlar, salça, yağ',
                  price: '25 TL',
                  imageUrl: 'https://example.com/izgara_tavuk.jpg',
                ),
                MenuItem(
                  name: 'Sebzeli Kebap',
                  ingredients: 'Kuşbaşı et, patlıcan, biber, domates',
                  price: '30 TL',
                  imageUrl: 'https://example.com/sebzeli_kebap.jpg',
                ),
                // Diğer ana yemek örnekleri...
              ],
            ),
            CategoryCard(
              category: 'Ara Sıcak',
              items: [
                MenuItem(
                  name: 'Sigara Böreği',
                  ingredients: 'Yufka, peynir, maydanoz, yağ',
                  price: '8 TL',
                  imageUrl: 'https://example.com/sigara_boregi.jpg',
                ),
                MenuItem(
                  name: 'Patates Kızartması',
                  ingredients: 'Patates, yağ, tuz',
                  price: '7 TL',
                  imageUrl: 'https://example.com/patates_kizartmasi.jpg',
                ),
                // Diğer ara sıcak örnekleri...
              ],
            ),
            CategoryCard(
              category: 'Tatlı',
              items: [
                MenuItem(
                  name: 'Baklava',
                  ingredients: 'Yufka, ceviz, şeker, tereyağı, şerbet',
                  price: '20 TL',
                  imageUrl: 'https://example.com/baklava.jpg',
                ),
                MenuItem(
                  name: 'Sütlaç',
                  ingredients: 'Süt, pirinç, şeker, vanilya, tarçın',
                  price: '15 TL',
                  imageUrl: 'https://example.com/sutlac.jpg',
                ),
                // Diğer tatlı örnekleri...
              ],
            ),
            CategoryCard(
              category: 'Atıştırmalık',
              items: [
                MenuItem(
                  name: 'Köfte',
                  ingredients: 'Dana kıyma, soğan, ekmek içi, baharatlar',
                  price: '18 TL',
                  imageUrl: 'https://example.com/kofte.jpg',
                ),
                MenuItem(
                  name: 'Sandviç',
                  ingredients: 'Ekmek, salam, peynir, marul, domates',
                  price: '10 TL',
                  imageUrl: 'https://example.com/sandvic.jpg',
                ),
                // Diğer atıştırmalık örnekleri...
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final List<MenuItem> items;

  CategoryCard({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              category,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  items[index].imageUrl,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
                title: Text(items[index].name),
                subtitle: Text(
                    'Malzemeler: ${items[index].ingredients}\nFiyat: ${items[index].price}'),
                onTap: () {
                  // Tıklanan öğeyle ilgili bir işlem yapılabilir
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String ingredients;
  final String price;
  final String imageUrl;

  MenuItem(
      {required this.name,
      required this.ingredients,
      required this.price,
      required this.imageUrl});
}
