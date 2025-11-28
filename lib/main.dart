import 'dart:async';
import 'package:flutter/material.dart';

// --- 1. CONFIG & THEME ---
class AppTheme {
  static const Color bgColor1 = Color(0xFF1F1D2B); // Background Utama (Gelap)
  static const Color bgColor2 = Color(0xFF2B2937); // Background Secondary (Card/Input)
  static const Color bgColor3 = Color(0xFF242231); // Background Bottom Nav
  static const Color bgColorTopDetail = Color(0xFFECEDEF); // Background Terang untuk area gambar detail
  static const Color primaryColor = Color(0xFF6C5ECF); // Ungu
  static const Color secondaryColor = Color(0xFF38ABBE); // Biru Laut / Cyan
  static const Color primaryTextColor = Color(0xFFF1F0F2); // Putih/Abu terang
  static const Color secondaryTextColor = Color(0xFF999999); // Abu medium
  static const Color subtitleColor = Color(0xFF504F5E); // Abu gelap
  static const Color priceColor = Color(0xFF2C96F1); // Biru Harga
  static const Color alertColor = Color(0xFFED6363); // Merah
  static const Color cardColor = Color(0xFFECEDEF); // Warna background sepatu di card (putih/abu terang)
}

void main() {
  runApp(const ShamoApp());
}

class ShamoApp extends StatelessWidget {
  const ShamoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shamo Store',
      theme: ThemeData(
        fontFamily: 'Poppins', 
        scaffoldBackgroundColor: AppTheme.bgColor1,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.bgColor1,
          elevation: 0,
          iconTheme: IconThemeData(color: AppTheme.primaryTextColor),
          titleTextStyle: TextStyle(color: AppTheme.primaryTextColor, fontSize: 18, fontWeight: FontWeight.w500),
          centerTitle: true,
        ),
         // Menghilangkan efek splash/highlight standar Android/iOS agar lebih mirip desain
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      routes: {
        '/': (context) => const SplashPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const MainPage(),
        '/detail-chat': (context) => const DetailChatPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/checkout-success': (context) => const CheckoutSuccessPage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/product-detail': (context) => const ProductDetailPage(), // Route Baru
      },
    );
  }
}

// --- 2. SPLASH SCREEN ---
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor1,
      body: Center(
        child: Container(
          width: 130, height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(image: NetworkImage('https://i.imgur.com/7te91C0.png')),
          ),
        ),
      ),
    );
  }
}

// --- 3. AUTH PAGES ---
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text("Login", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 24, fontWeight: FontWeight.w600)),
              const Text("Sign In to Continue", style: TextStyle(color: AppTheme.subtitleColor, fontSize: 14)),
              const SizedBox(height: 70),
              const CustomInput(label: "Email Address", icon: Icons.email, hint: "Your Email Address"),
              const SizedBox(height: 20),
              const CustomInput(label: "Password", icon: Icons.lock, hint: "Your Password", isPassword: true),
              const SizedBox(height: 30),
              CustomButton(text: "Sign In", onPressed: () => Navigator.pushNamed(context, '/home')),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: AppTheme.subtitleColor)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sign-up'),
                    child: const Text("Sign Up", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign Up", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              const CustomInput(label: "Full Name", icon: Icons.person, hint: "Your Full Name"),
              const SizedBox(height: 20),
              const CustomInput(label: "Username", icon: Icons.circle_outlined, hint: "Your Username"),
              const SizedBox(height: 20),
              const CustomInput(label: "Email", icon: Icons.email, hint: "Your Email"),
              const SizedBox(height: 20),
              const CustomInput(label: "Password", icon: Icons.lock, hint: "Your Password", isPassword: true),
              const SizedBox(height: 30),
              CustomButton(text: "Sign Up", onPressed: () => Navigator.pushNamed(context, '/home')),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account? ", style: TextStyle(color: AppTheme.subtitleColor)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Sign In", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. MAIN PAGE ---
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  Widget customBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        clipBehavior: Clip.antiAlias,
        color: AppTheme.bgColor3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.chat, 1),
              const SizedBox(width: 40),
              _navItem(Icons.favorite, 2),
              _navItem(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Icon(icon, color: currentIndex == index ? AppTheme.primaryColor : const Color(0xFF808191)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor1,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.shopping_bag, size: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomePage(),
          ChatListPage(),
          WishlistPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}

// --- 5. HOME PAGE ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All Shoes';
  final List<Map<String, dynamic>> products = [
    {'name': 'Terrex Urban Low', 'cat': 'Hiking', 'price': 143.98, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg'},
    {'name': 'Ultra 4D 5 Shoes', 'cat': 'Running', 'price': 285.73, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c20573e88107406e8854af6a01423455_9366/Ultra_4D_Shoes_Black_GX6366_01_standard.jpg'},
    {'name': 'SL 20 Shoes', 'cat': 'Running', 'price': 123.82, 'img': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/28e3b092323e449c8369aabc00d07412_9366/SL20_Shoes_Black_EG1144_01_standard.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(height: 30),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Hallo, Alex", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold)),
              Text("@alexkeinn", style: TextStyle(color: AppTheme.subtitleColor, fontSize: 16)),
            ])),
            const CircleAvatar(radius: 27, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
          ]),
          const SizedBox(height: 30),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['All Shoes','Running','Training','Basketball','Hiking'].map((e) => 
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selectedCategory == e ? AppTheme.primaryColor : Colors.transparent,
                border: Border.all(color: selectedCategory == e ? Colors.transparent : AppTheme.subtitleColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onTap: () => setState(() => selectedCategory = e),
                child: Text(e, style: TextStyle(color: selectedCategory == e ? AppTheme.primaryTextColor : AppTheme.subtitleColor)),
              ),
            )
          ).toList())),
          const SizedBox(height: 30),
          const Text("Popular Products", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: products.map((p) => ProductCard(p)).toList())),
          const SizedBox(height: 30),
          const Text("New Arrivals", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Column(children: products.map((p) => ProductTile(p)).toList()),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// --- 6. CHAT SECTION ---
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});
  @override
  Widget build(BuildContext context) {
    bool hasChat = true; 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message Support"),
        automaticallyImplyLeading: false,
      ),
      body: hasChat ? ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/detail-chat'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  const CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Icon(Icons.store, color: AppTheme.secondaryColor)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shoe Store", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 15, fontWeight: FontWeight.bold)),
                        Text("Good night, This item is on...", style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 14, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                  const Text("Now", style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 10)),
                ],
              ),
            ),
          )
        ],
      ) : const Center(child: Text("Opss no message yet?", style: TextStyle(color: Colors.white))),
    );
  }
}

class DetailChatPage extends StatelessWidget {
  const DetailChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor3,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor1,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.store, color: AppTheme.secondaryColor)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("Shoe Store", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 14)),
              Text("Online", style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12)),
            ]),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                const SizedBox(height: 30),
                Align(alignment: Alignment.centerRight, child: _productPreview()),
                _chatBubble(text: "Hi, This item is still available?", isSender: true),
                _chatBubble(text: "Good night, This item is only available in size 42 and 43", isSender: false),
                _chatBubble(text: "Owww, it suits me very well", isSender: true),
              ],
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  Widget _productPreview() {
    return Container(
      width: 230, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF2B2844), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primaryColor)),
      child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network('https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83906a596041492ba262ab9e01168f2d_9366/Predator_Mutator_20.1_Firm_Ground_Boots_Black_EF1629_01_standard.jpg', width: 54, fit: BoxFit.cover)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text("COURT VISION...", style: TextStyle(color: AppTheme.primaryTextColor, overflow: TextOverflow.ellipsis)),
              SizedBox(height: 4),
              Text("\$57,15", style: TextStyle(color: AppTheme.priceColor)),
            ])),
          const CircleAvatar(radius: 12, backgroundColor: AppTheme.secondaryColor, child: Icon(Icons.close, size: 14)),
      ]),
    );
  }

  Widget _chatBubble({required String text, required bool isSender}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF2B2844) : const Color(0xFF252836),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(isSender ? 12 : 0), topRight: Radius.circular(isSender ? 0 : 12), bottomLeft: const Radius.circular(12), bottomRight: const Radius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(color: AppTheme.primaryTextColor)),
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(children: [
          Expanded(child: Container(height: 45, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)), child: TextFormField(style: const TextStyle(color: AppTheme.primaryTextColor), decoration: const InputDecoration.collapsed(hintText: "Type Message...", hintStyle: TextStyle(color: AppTheme.subtitleColor))))),
          const SizedBox(width: 20),
          Container(height: 45, width: 45, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.send, color: Colors.white)),
      ]),
    );
  }
}

// --- 7. WISHLIST / FAVORITE PAGE ---
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasFavorites = true; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Shoes"),
        automaticallyImplyLeading: false,
      ),
      body: hasFavorites 
        ? ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              const SizedBox(height: 20),
              _wishlistCard('Terrex Urban Low', 143.98, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg'),
              _wishlistCard('Predator 20.3 Firm', 68.47, 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83906a596041492ba262ab9e01168f2d_9366/Predator_Mutator_20.1_Firm_Ground_Boots_Black_EF1629_01_standard.jpg'),
              const SizedBox(height: 80),
            ],
          )
        : _emptyState(),
    );
  }

  Widget _wishlistCard(String name, double price, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 10, left: 12, bottom: 14, right: 20),
      decoration: BoxDecoration(
        color: AppTheme.bgColor2, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60, height: 60,
              color: Colors.white,
              child: Image.network(img, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: AppTheme.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w600)),
                Text("\$$price", style: const TextStyle(color: AppTheme.priceColor, fontSize: 14)),
              ],
            ),
          ),
          const CircleAvatar(
            backgroundColor: AppTheme.secondaryColor,
            radius: 17,
            child: Icon(Icons.favorite, size: 18, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 74, color: AppTheme.secondaryColor),
          const SizedBox(height: 23),
          const Text("You don't have dream shoes?", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          const Text("Let's find your favorite shoes", style: TextStyle(color: AppTheme.secondaryTextColor)),
          const SizedBox(height: 20),
          SizedBox(
            height: 44,
            width: 152,
            child: ElevatedButton(
              onPressed: (){}, 
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Explore Store")
            ),
          )
        ],
      ),
    );
  }
}

// --- 8. CART & CHECKOUT ---
class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor3,
      appBar: AppBar(
        title: const Text("Your Cart"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(padding: const EdgeInsets.symmetric(horizontal: 30), children: [const SizedBox(height: 30), _cartItem(), _cartItem()]),
          ),
          Container(
            height: 165, decoration: const BoxDecoration(color: AppTheme.bgColor1), padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("Subtotal", style: TextStyle(color: AppTheme.primaryTextColor)), Text("\$287,96", style: TextStyle(color: AppTheme.priceColor, fontWeight: FontWeight.bold, fontSize: 16))]),
                const SizedBox(height: 30),
                SizedBox(height: 50, width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/checkout'), style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("Continue to Checkout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), Icon(Icons.arrow_forward, size: 20)]))),
            ]),
          )
        ],
      ),
    );
  }
  Widget _cartItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, image: const DecorationImage(image: NetworkImage('https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg'), fit: BoxFit.contain))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Terrex Urban Low", style: TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w600)), Text("\$143,98", style: TextStyle(color: AppTheme.priceColor))])),
              Column(children: [Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 20), const SizedBox(height: 2), const Text("2", style: TextStyle(color: AppTheme.primaryTextColor)), const SizedBox(height: 2), const Icon(Icons.remove_circle, color: Color(0xFF3F4251), size: 20)])
          ]),
          const SizedBox(height: 12),
          Row(children: const [Icon(Icons.delete, color: AppTheme.alertColor, size: 16), SizedBox(width: 4), Text("Remove", style: TextStyle(color: AppTheme.alertColor, fontSize: 12))])
      ]),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor3,
      appBar: AppBar(title: const Text("Checkout Details"), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          const Text("List Items", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          _itemRow(), _itemRow(),
          const SizedBox(height: 30),
          const Text("Address Details", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)), child: Column(children: [_addressRow(Icons.store, "Store Location", "Adidas Core"), _addressRow(Icons.location_on, "Your Address", "Marsemoon")])),
          const SizedBox(height: 30),
          const Text("Payment Summary", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)), child: Column(children: [_summaryRow("Product Quantity", "2 Items"), const SizedBox(height: 12), _summaryRow("Product Price", "\$575.96"), const SizedBox(height: 12), _summaryRow("Shipping", "Free"), const SizedBox(height: 12), const Divider(color: Color(0xFF2E3141)), const SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("Total", style: TextStyle(color: AppTheme.priceColor, fontWeight: FontWeight.w600)), Text("\$575.92", style: TextStyle(color: AppTheme.priceColor, fontWeight: FontWeight.w600))])])),
          const SizedBox(height: 30),
          CustomButton(text: "Checkout Now", onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/checkout-success', (route) => false)),
        ],
      ),
    );
  }
  Widget _itemRow() => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), image: const DecorationImage(image: NetworkImage('https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg')))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Terrex Urban Low", style: TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w600)), Text("\$143,98", style: TextStyle(color: AppTheme.priceColor))])), const Text("2 Items", style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12))]));
  Widget _addressRow(IconData icon, String title, String val) => Row(children: [Column(children: [Icon(icon, color: AppTheme.secondaryColor, size: 40), Container(height: 30, width: 2, color: AppTheme.bgColor2)]), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12)), Text(val, style: const TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w500))])]);
  Widget _summaryRow(String label, String val) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12)), Text(val, style: const TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w500))]);
}

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor3,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 80, color: AppTheme.secondaryColor),
            const SizedBox(height: 20),
            const Text("You made a transaction", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text("Stay at home while we\nprepare your dream shoes", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.secondaryTextColor)),
            const SizedBox(height: 30),
            SizedBox(width: 196, child: CustomButton(text: "Order Other Shoes", onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false))),
          ],
        ),
      ),
    );
  }
}

// --- 9. PROFILE PAGES ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor3,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Hallo, Alex", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 24, fontWeight: FontWeight.w600)),
                      Text("@alexkeinn", style: TextStyle(color: AppTheme.subtitleColor, fontSize: 16)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false),
                  icon: const Icon(Icons.exit_to_app, color: AppTheme.alertColor, size: 30)
                )
              ],
            ),
            const SizedBox(height: 50),
            const Text("Account", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _menuItem(context, "Edit Profile", onTap: () => Navigator.pushNamed(context, '/edit-profile')),
            _menuItem(context, "Your Orders"),
            _menuItem(context, "Help"),
            const SizedBox(height: 30),
            const Text("General", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _menuItem(context, "Privacy & Policy"),
            _menuItem(context, "Term of Service"),
            _menuItem(context, "Rate App"),
             const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 13)),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryTextColor),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text("Edit Profile"),
        actions: [IconButton(icon: const Icon(Icons.check, color: AppTheme.primaryColor), onPressed: () {})],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30), width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
            const SizedBox(height: 30),
            _inputField("Name", "Alex keinnzal"),
            _inputField("Username", "@alexkeinn"),
            _inputField("Email Address", "alex.kein@gmail.com"),
          ],
        ),
      ),
    );
  }
  Widget _inputField(String label, String initValue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 13)),
          TextFormField(
            initialValue: initValue,
            style: const TextStyle(color: AppTheme.primaryTextColor),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.subtitleColor)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor)),
            ),
          )
        ],
      ),
    );
  }
}

// --- 10. PRODUCT DETAIL PAGE (NEW & FINAL) ---
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;
  bool _isWishlist = false;
  
  // Dummy images for carousel
  final List<String> imgList = [
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a6381273949f4c33b708aae101235e95_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_01_standard.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8a47c907484e42339131aae101236773_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_02_standard_hover.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83972848643246508367aae1012371e5_9366/Terrex_AX4_Primegreen_Hiking_Shoes_Black_FY9673_03_standard.jpg',
  ];

  // Dummy familiar shoes
  final List<String> familiarShoes = [
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c690225102a04870bf02ac2e01237c22_9366/adidas_x_LEGO(r)_Sport_Shoes_Red_FY8440_01_standard.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/28e3b092323e449c8369aabc00d07412_9366/SL20_Shoes_Black_EG1144_01_standard.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/5e090623126f43708e33ac4c010a3407_9366/Dame_7_Extply_Shoes_Blue_GV9872_01_standard.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/83906a596041492ba262ab9e01168f2d_9366/Predator_Mutator_20.1_Firm_Ground_Boots_Black_EF1629_01_standard.jpg',
    'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/c20573e88107406e8854af6a01423455_9366/Ultra_4D_Shoes_Black_GX6366_01_standard.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // Menggunakan Stack untuk menumpuk gambar di bawah konten
    return Scaffold(
      backgroundColor: AppTheme.bgColorTopDetail, // Background terang untuk area gambar
      body: Stack(
        children: [
          // 1. Image Carousel di Layer paling bawah
          _buildImageCarousel(),
          
          // 2. Custom AppBar di atas gambar
          _buildCustomAppBar(context),

          // 3. Konten Utama (Draggable/Scrollable Sheet)
          _buildMainContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 350, // Tinggi area gambar
          child: PageView.builder(
            itemCount: imgList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                imgList[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Indikator titik
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppTheme.primaryColor
                    : const Color(0xFFC4C4C4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    // Menggunakan SafeArea hanya untuk bagian atas agar tidak tertutup status bar
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Icon hitam di background terang
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag, color: Colors.black),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    // Container dengan margin atas agar menumpuk gambar
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 400),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        color: AppTheme.bgColor1, // Warna background gelap utama
      ),
      child: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          // Header Title & Wishlist Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("TERREX URBAN LOW", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 18, fontWeight: FontWeight.w600)),
                    Text("Hiking", style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isWishlist = !_isWishlist;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _isWishlist ? AppTheme.secondaryColor : AppTheme.alertColor,
                      content: Text(
                        _isWishlist ? "Has been added to the Whitelist" : "Has been removed from the Whitelist",
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 1),
                    )
                  );
                },
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: AppTheme.bgColor2,
                  child: Icon(Icons.favorite, color: _isWishlist ? AppTheme.secondaryColor : const Color(0xFF504F5E)),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Price Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Price starts from", style: TextStyle(color: AppTheme.primaryTextColor)),
                Text("\$143,98", style: TextStyle(color: AppTheme.priceColor, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Description
          const Text("Description", style: TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          const Text("Unpaved trails and mixed surfaces are easy when you have the traction and support you need. Casual enough for the daily commute.", style: TextStyle(color: AppTheme.secondaryTextColor, fontWeight: FontWeight.w300), textAlign: TextAlign.justify),
          const SizedBox(height: 30),

          // Familiar Shoes
          const Text("Fimiliar Shoes", style: TextStyle(color: AppTheme.primaryTextColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: familiarShoes.map((imageUrl) {
                return Container(
                  width: 54, height: 54,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background putih untuk gambar kecil
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: AppTheme.bgColor1,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          // Chat Button (Outlined)
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor),
            ),
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, '/detail-chat'),
              icon: const Icon(Icons.chat_bubble, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart Button (Filled)
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  showSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Fungsi untuk memunculkan Dialog Sukses
  Future<void> showSuccessDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.bgColor3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: AppTheme.primaryTextColor))),
                const Icon(Icons.check_circle_outline, color: AppTheme.secondaryColor, size: 100),
                const SizedBox(height: 12),
                const Text("Hurray :)", style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text("Item added successfully", style: TextStyle(color: AppTheme.secondaryTextColor)),
                const SizedBox(height: 20),
                SizedBox(
                  width: 154, height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("View My Cart")
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- 11. REUSABLE WIDGETS (Updated with Navigation to Detail) ---
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductCard(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail'),
      child: Container(
        width: 215, height: 278, margin: const EdgeInsets.only(right: 30), decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(20)),
        child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 30), Image.network(data['img'], height: 120, width: 215, fit: BoxFit.contain), const Spacer(), Text(data['cat'], style: const TextStyle(color: Color(0xFF999999), fontSize: 12)), Text(data['name'], style: const TextStyle(color: Color(0xFF2E2E2E), fontSize: 18, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis), Text("\$${data['price']}", style: const TextStyle(color: AppTheme.priceColor, fontWeight: FontWeight.w500))])),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductTile(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-detail'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(width: 120, height: 120, color: AppTheme.cardColor, child: Image.network(data['img'], fit: BoxFit.contain))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['cat'], style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 12)), Text(data['name'], style: const TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w600)), Text("\$${data['price']}", style: const TextStyle(color: AppTheme.priceColor, fontWeight: FontWeight.w500))]))]),
      ),
    );
  }
}

// (CustomInput dan CustomButton tetap sama, tidak perlu diubah)
class CustomInput extends StatelessWidget {
  final String label; final IconData icon; final String hint; final bool isPassword;
  const CustomInput({super.key, required this.label, required this.icon, required this.hint, this.isPassword = false});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
      const SizedBox(height: 12),
      Container(height: 50, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: AppTheme.bgColor2, borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, color: AppTheme.primaryColor, size: 17), const SizedBox(width: 16), Expanded(child: TextFormField(obscureText: isPassword, style: const TextStyle(color: AppTheme.primaryTextColor), decoration: InputDecoration.collapsed(hintText: hint, hintStyle: const TextStyle(color: AppTheme.subtitleColor))))])),
    ]);
  }
}

class CustomButton extends StatelessWidget {
  final String text; final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 50, width: double.infinity, child: TextButton(onPressed: onPressed, style: TextButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(text, style: const TextStyle(color: AppTheme.primaryTextColor, fontSize: 16, fontWeight: FontWeight.w500))));
  }
}