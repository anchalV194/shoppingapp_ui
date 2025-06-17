import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';
import 'landing_page.dart';
import 'login_page.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: LandingPage(),
            routes: {
              '/main': (_) => MainNavigation(), // After successful login/signup
            },
          );
        },
      ),
    ),
  );
}
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class AmazonCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1F1F1F),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF121212),
        ),
      ),

      home: MainNavigation(),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String image;
  final String category;

  Product({required this.name, required this.price, required this.image, required this.category});
}

class AppState extends ChangeNotifier {
  List<CartItem> cart = [];
  List<Product> wishlist = [];

  void addToCart(Product product) {
    final existing = cart.firstWhere(
          (item) => item.product.name == product.name,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existing.quantity == 0) {
      cart.add(CartItem(product: product));
    } else {
      existing.quantity++;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cart.removeWhere((item) => item.product.name == product.name);
    notifyListeners();
  }

  void addToWishlist(Product product) {
    if (!wishlist.contains(product)) {
      wishlist.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    wishlist.remove(product);
    notifyListeners();
  }
}

final List<Product> allProducts = [
  Product(
    name: 'iPhone 13 ',
    price: 79999,
    image: 'assets/images/iphone.jpg',
    category: 'Mobiles',
  ),
  Product(
    name: 'Apple Watch (S6)',
    price: 39999,
    image: 'assets/images/watch.jpg',
    category: 'Watches',
  ),
  Product(
    name: 'MacBook Pro',
    price: 159999,
    image: 'assets/images/macbook.jpeg',
    category: 'Electronics',
  ),
  Product(
    name: 'T-Shirt',
    price: 999,
    image: 'assets/images/tshirt.jpg',
    category: 'Fashion',
  ),
  Product(
    name: 'Harry Potter Book Set',
    price: 2999,
    image: 'assets/images/harry-potter.jpg',
    category: 'Books',
  ),
  Product(
    name: 'Sofa Set',
    price: 29999,
    image: 'assets/images/sofa.jpeg',
    category: 'Home',
  ),
  Product(
    name: 'UBL Speaker',
    price: 1599,
    image: 'assets/images/speaker.jpg',
    category: 'Electronics',
  ),
  Product(
    name: 'Samsung Watch 4',
    price: 15999,
    image: 'assets/images/samsung-watch.jpg',
    category: 'Watches',
  ),
];

class MainNavigation extends StatefulWidget {
  static final GlobalKey<_MainNavigationState> navKey = GlobalKey();

  MainNavigation() : super(key: navKey);

  @override
  _MainNavigationState createState() => _MainNavigationState();
}
class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomePage(), WishlistPage(), CartPage(), ProfilePage()];

  void setTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) => setTab(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';

  List<String> categories = ['All', 'Mobiles', 'Fashion', 'Home', 'Electronics', 'Watches'];

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = selectedCategory == 'All'
        ? allProducts
        : allProducts.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.orange),
            SizedBox(width: 8),
            Text("amazingfy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/user.jpeg')),
          SizedBox(width: 10),
        ],
      ),
      drawer: buildDrawer(),
      body: ListView(
        children: [
          buildSearchBar(),
          buildPromotionalBanner(),
          buildDealOfTheDay(),
          buildCategoryChips(),
          buildProductSection("Popular Products", filteredProducts),
          buildProductSection(
            "Recommended for You",
            allProducts.where((product) => product.name.toLowerCase().contains('macbook')).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for products, brands and more',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildPromotionalBanner() {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          Image.asset('assets/images/banner1.jpeg', fit: BoxFit.cover),
          Image.asset('assets/images/banner2.jpeg', fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget buildDealOfTheDay() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deal of the Day", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/iphone.jpg', width: 100, height: 100),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("iPhone 13", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ 74,999", style: TextStyle(color: Colors.green)),
                    Text("Limited time offer!", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ChoiceChip(
                label: Text(categories[index]),
                selected: selectedCategory == categories[index],
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = categories[index];
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildProductSection(String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ProductPage(product: product),
                  ));
                },
                child: Hero(
                  tag: product.name,
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(product.image, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("₹ ${product.price}", style: TextStyle(color: Colors.greenAccent)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF2A2A2A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF121212)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/user.jpeg')),
                SizedBox(height: 10),
                Text('Hello, Anchal Verma', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          ...[
            "Home", "Shop by Category", "Your Orders", "Buy Again", "Your Wishlist",
            "Your Account", "Amazon Pay", "Prime", "Sell on Amazon", "Settings", "Support"
          ].map((text) => ListTile(
            title: Text(text),
            onTap: () {},
          )),
          ListTile(
            title: Text('Log Out'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  final Product product;
  ProductPage({required this.product});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {
  String selectedStorage = "32gb";
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getProductDescription(String name) {
    switch (name.toLowerCase()) {
      case 'iphone 13 (128gb)':
        return 'iPhone 13 features a sleek design, powerful A15 Bionic chip, and an advanced dual-camera system for better low-light performance.';
      case 'apple watch (s6)':
        return 'Apple Watch Series 6 helps you measure your blood oxygen level, take an ECG anytime, and see your fitness metrics at a glance.';
      case 'macbook pro':
        return 'MacBook Pro delivers game-changing performance for pro users. With the M1 chip, it offers blazing speed and incredible battery life.';
      case 't-shirt':
        return 'Comfortable and stylish cotton T-shirt perfect for casual wear. Available in multiple colors and sizes.';
      case 'harry potter book set':
        return 'Complete Harry Potter book set including all 7 novels by J.K. Rowling. A perfect gift for fans and collectors.';
      default:
        return 'This is a great product from our collection. High quality and well-reviewed by customers.';
    }
  }

  bool showStorageOptions(String name) {
    final lower = name.toLowerCase();
    return lower.contains("iphone") || lower.contains("macbook");
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => appState.addToWishlist(product),
          )
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(product.image, height: 250, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('₹ ${product.price}', style: TextStyle(fontSize: 22, color: Colors.orange, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Text('₹ ${(product.price * 1.1).round()}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        SizedBox(width: 8),
                        Text('5% off', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                      ],
                    ),
                    if (showStorageOptions(product.name)) ...[
                      SizedBox(height: 16),
                      Text("Storage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ChoiceChip(
                            label: Text("128gb"),
                            selected: selectedStorage == "128gb",
                            onSelected: (_) {
                              setState(() {
                                selectedStorage = "128gb";
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          ChoiceChip(
                            label: Text("256gb"),
                            selected: selectedStorage == "256gb",
                            onSelected: (_) {
                              setState(() {
                                selectedStorage = "256gb";
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 20),
                    Text("Delivery Options", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ListTile(
                      title: Text("Deliver to Anchal Verma"),
                      subtitle: Text("Civil Lines, Raipur 208001"),
                      trailing: ElevatedButton(onPressed: () {}, child: Text("Change")),
                    ),
                    Divider(),
                    Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      getProductDescription(product.name),
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => appState.addToCart(product),
                          child: Text("Add to Cart"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Buy Now"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final wishlist = appState.wishlist;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist", style: TextStyle(letterSpacing: 1.5)),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.short_text),
          )
        ],
      ),
      body: SafeArea(
        child: wishlist.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Your Wishlist is Empty",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Tap heart button to start saving your favorite items.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  MainNavigation.navKey.currentState?.setTab(0);
                },
                child: Text("Add Now"),
              )

            ],
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("All Items"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlist[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "₹ ${product.price}",
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[300] : Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite, color: Colors.red),
                                      onPressed: () => appState.removeFromWishlist(product),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        appState.addToCart(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Added to cart"),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: Text("Add to Cart"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cart = appState.cart;

    double subtotal = cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);
    double tax = subtotal * 0.01;
    double delivery = 49.0;
    double promoDiscount = 0.0;
    double total = subtotal + tax + delivery - promoDiscount;

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Your Cart is Empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Start shopping and add items to your cart.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                MainNavigation.navKey.currentState?.setTab(0); // Go to Home
              },
              child: Text("Add Now"),
            )
          ],
        ),
      )
          : Padding(

      padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    color: Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  item.quantity++;
                                  appState.notifyListeners();
                                },
                              ),
                              Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    item.quantity--;
                                  } else {
                                    appState.cart.removeAt(index);
                                  }
                                  appState.notifyListeners();
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          Image.asset(item.product.image, width: 60, height: 60),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("₹ ${item.product.price}", style: TextStyle(color: Colors.blueAccent)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              appState.cart.removeAt(index);
                              appState.notifyListeners();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Promo Code",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text("Apply")),
              ],
            ),
            SizedBox(height: 16),
            buildSummaryRow("Cart total", subtotal),
            buildSummaryRow("Tax", tax),
            buildSummaryRow("Delivery", delivery),
            buildSummaryRow("Promo discount", -promoDiscount),
            Divider(),
            buildSummaryRow("Subtotal", total, isBold: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text("Proceed to Checkout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSummaryRow(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("₹ ${amount.toStringAsFixed(2)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = true;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController(text: 'Anchal Verma');
  final emailController = TextEditingController(text: 'av@gmail.com');
  final addressController = TextEditingController(
      text: '123, Civil Lines, Raipur');
  final phoneController = TextEditingController(text: '+91-1234567890');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF1C1C1C) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                Icons.settings, color: isDark ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/user.jpeg'),
          ),
          SizedBox(height: 12),
          TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(border: InputBorder.none),
          ),
          TextField(
            controller: emailController,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(border: InputBorder.none),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                buildEditableTile(
                    Icons.home_outlined, "Address", addressController, isDark),
                buildEditableTile(
                    Icons.phone_outlined, "Phone", phoneController, isDark),
                buildStaticTile(
                    Icons.privacy_tip_outlined, "Privacy Policy", isDark),
                buildStaticTile(Icons.help_outline, "Support", isDark),
                SwitchListTile(
                  title: Text("Dark Mode", style: TextStyle(
                      color: isDark ? Colors.white : Colors.black)),
                  secondary: Icon(Icons.brightness_6,
                      color: isDark ? Colors.white : Colors.black),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Logout", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout, size: 40, color: Colors.red),
                              SizedBox(height: 16),
                              Text("Are you sure you want to logout?", style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () {
                                      Navigator.pop(context); // Close bottom sheet
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (_) => LandingPage()), // ⬅️ Make sure it's imported
                                            (route) => false,
                                      );
                                    },
                                    child: Text("Logout"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableTile(IconData icon, String label,
      TextEditingController controller, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
      title: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildStaticTile(IconData icon, String label, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
      title: Text(
          label, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
      onTap: () {},
    );
  }

  void showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 40, color: Colors.redAccent),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to log out?",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                      ),
                      child: Text(
                          "Cancel", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (route) => false);
                      },
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
