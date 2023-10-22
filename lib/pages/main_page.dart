import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/income_screen.dart';
import 'package:expense_tracker/screens/expense_screen.dart';
import 'package:expense_tracker/screens/reports_screen.dart';
import 'package:expense_tracker/widgets/bottom_navigation_widget.dart';
import 'package:expense_tracker/widgets/top_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const IncomeScreen(),
    const ExpenseScreen(),
    const ReportScreen(),
  ];

  void _onBottomNavIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationWidget(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF429690),
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://i.pravatar.cc/150?img=7', // Put user image URL here
                    ),
                  ),
                  SizedBox(), // Gives some spacing between the image and text
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            // add nice looking list tile
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            // to into screen
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/intro');
              },
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final bool? shouldLogout =
                    await _showLogoutConfirmationDialog();
                if (shouldLogout == true) {
                  try {
                    await _auth.signOut();
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/login');
                  } catch (error) {
                    print("Error signing out: $error");
                    // Optionally show a message to the user
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar:
          BottomNavigationWidget(onItemSelected: _onBottomNavIndexChanged),
    );
  }

  Future<bool?> _showLogoutConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
