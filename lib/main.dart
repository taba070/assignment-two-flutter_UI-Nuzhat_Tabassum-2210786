import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 2 - Flutter APP UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

// ---------------- MAIN SCREEN WITH BOTTOM NAVIGATION + PAGEVIEW ----------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: const [
          HomePage(),
          CardsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => _currentIndex = i);
          _pageController.jumpToPage(i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Cards"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ---------------- HELPER: SHOW SNACKBAR ON TAP ----------------

void showTapMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.indigo,
    ),
  );
}

// ---------------- COMMON TOP BAR (Welcome back, STUDENT NAME) ----------------

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text("NT", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome back,", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Nuzhat Tabassum",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => showTapMessage(context, "No new notifications"),
          child: Stack(
            children: [
              const Icon(Icons.notifications_none, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------- PAGE 1: HOME ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"title": "Netflix Subscription", "sub": "Entertainment • Today", "amount": "-৳19.99"},
      {"title": "Coffee Shop", "sub": "Food & Drink • Today", "amount": "-৳4.50"},
      {"title": "Salary Deposit", "sub": "Income • Yesterday", "amount": "+৳3500.00"},
      {"title": "Grocery Store", "sub": "Shopping • Yesterday", "amount": "-৳55.80"},
      {"title": "Amazon Purchase", "sub": "Shopping • 2 days ago", "amount": "-৳120.45"},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 20),
              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Balance",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                        GestureDetector(
                          onTap: () => showTapMessage(context, "Balance copied"),
                          child: const Icon(Icons.copy, color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text("৳8,945.32",
                        style: TextStyle(
                            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Savings: ৳5,500", style: TextStyle(color: Colors.white70)),
                        Text("Last 30 days: +৳300 →",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _quickAction(context, Icons.swap_vert, "Transfer"),
                  _quickAction(context, Icons.receipt_long, "Pay Bills"),
                  _quickAction(context, Icons.trending_up, "Invest"),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent Transactions",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () => showTapMessage(context, "Showing all transactions"),
                    child: const Text("View All", style: TextStyle(color: Colors.indigo)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...transactions.map((t) => _transactionTile(
                    context,
                    t["title"]!,
                    t["sub"]!,
                    t["amount"]!,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () => showTapMessage(context, "$label tapped"),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.indigo.shade50,
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _transactionTile(BuildContext context, String title, String sub, String amount) {
    final isNegative = amount.startsWith("-");
    return GestureDetector(
      onTap: () => showTapMessage(context, "$title • $amount"),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.indigo, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: isNegative ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- PAGE 3: MY CARDS ----------------

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 20),
              const Text("My Cards",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16),
              // Card widget
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 30,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Text("BANK",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("4567  ****  ****  1234",
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, letterSpacing: 2)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("CARD HOLDER",
                                style: TextStyle(color: Colors.white54, fontSize: 10)),
                            Text("Nuzhat Tabassum",
                                style: TextStyle(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("EXPIRES",
                                style: TextStyle(color: Colors.white54, fontSize: 10)),
                            Text("12/28",
                                style: TextStyle(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _cardAction(context, Icons.block, "Block"),
                  _cardAction(context, Icons.credit_card, "Details"),
                  _cardAction(context, Icons.info_outline, "Limit"),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Linked Accounts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => showTapMessage(context, "Opening Shared Savings"),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text("S", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shared Savings", style: TextStyle(fontWeight: FontWeight.w600)),
                            Text("৳5,500.00", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () => showTapMessage(context, "$label tapped"),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.indigo.shade50,
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------- PAGE 4: USER PROFILE ----------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 20),
              const Center(
                child: Text("User Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.indigo,
                  child: Text("NT", style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
              const SizedBox(height: 20),
              _profileField("Name", "Nuzhat Tabassum"),
              _profileField("Student ID", "2210786"),
              _profileField("Email", "2210786@iub.edu.bd"),
              const SizedBox(height: 10),
              const Text("Bio / Story",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 4),
                  ],
                ),
                child: const Text(
                  "Hi, I'm Nuzhat Tabassum! I write code, drink coffee, and tell everyone "
                  "\"it's just one small change\" before spending three hours fixing it. "
                  "Welcome to my developer life!",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}