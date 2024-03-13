import 'package:flutter/material.dart';

import 'my_widgets.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'MENÜ',
          style: TextStyle(color: Colors.white, fontFamily: 'PermanentMarker'),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: WidgetBackcolor(
          Colors.brown,
          Colors.grey,
        ),
        child: SingleChildScrollView(
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
                    imageUrl: 'assets/images/mercimek_corbasi.webp',
                  ),
                  MenuItem(
                    name: 'Domates Çorbası',
                    ingredients: 'Domates, soğan, un, tuz, biber',
                    price: '12 TL',
                    imageUrl: 'assets/images/domates_corbasi.webp',
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
                    imageUrl: 'assets/images/izgara_tavuk.webp',
                  ),
                  MenuItem(
                    name: 'Sebzeli Kebap',
                    ingredients: 'Kuşbaşı et, patlıcan, biber, domates',
                    price: '30 TL',
                    imageUrl: 'assets/images/sebzeli_kebap.jpg',
                  ),
                  MenuItem(
                    name: 'Köfte',
                    ingredients: 'Dana kıyma, soğan, ekmek içi, baharatlar',
                    price: '18 TL',
                    imageUrl: 'assets/images/kofte.jpg',
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
                    imageUrl: 'assets/images/sigara_boregi.jpg',
                  ),
                  MenuItem(
                    name: 'Patates Kızartması',
                    ingredients: 'Patates, yağ, tuz',
                    price: '7 TL',
                    imageUrl: 'assets/images/patates_kizartmasi.webp',
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
                    imageUrl: 'assets/images/baklava.jpg',
                  ),
                  MenuItem(
                    name: 'Sütlaç',
                    ingredients: 'Süt, pirinç, şeker, vanilya, tarçın',
                    price: '15 TL',
                    imageUrl: 'assets/images/sutlac.webp',
                  ),
                  // Diğer tatlı örnekleri...
                ],
              ),
              CategoryCard(
                category: 'Atıştırmalık',
                items: [
                  MenuItem(
                    name: 'Sandviç',
                    ingredients: 'Ekmek, salam, peynir, marul, domates',
                    price: '10 TL',
                    imageUrl: 'assets/images/sandvic.jpg',
                  ),
                  // Diğer atıştırmalık örnekleri...
                ],
              ),
            ],
          ),
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
      child: Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                category,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontFamily: 'MadimiOne'),
              ),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 80.0,
                    height: 80.0,
                    child: Image.asset(
                      items[index].imageUrl,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    items[index].name,
                    style: TextStyle(
                      color: Colors.brown,
                      fontFamily: 'MadimiOne',
                    ),
                  ),
                  subtitle: Text(
                    'Malzemeler: ${items[index].ingredients}\nFiyat: ${items[index].price}',
                    style: TextStyle(
                      color: Colors.brown[300],
                    ),
                  ),
                  onTap: () {
                    // Tıklanan öğeyle ilgili bir işlem yapılabilir
                  },
                );
              },
            ),
          ],
        ),
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
