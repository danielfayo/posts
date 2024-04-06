import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posts/firebase_options.dart';
import 'package:posts/screens/auth_screen.dart';
import 'package:posts/screens/posts_screen.dart';
import 'package:posts/screens/profile_screen.dart';
import 'package:posts/screens/search_screen.dart';
import 'package:flutter_svg/svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PostsApp());
}

class PostsApp extends StatelessWidget {
  PostsApp({super.key});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.dmSansTextTheme()),
      home: _auth.currentUser == null ? AuthScreen() : const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const PostsScreen(),
    const SearchScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentScreen],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            currentIndex: _currentScreen,
            onTap: (int index) {
              setState(() {
                _currentScreen = index;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  "images/filled-home.svg",
                  semanticsLabel: "home",
                  height: 24,
                  width: 24,
                ),
                icon: SvgPicture.asset(
                  "images/line-home.svg",
                  semanticsLabel: "home",
                  height: 24,
                  width: 24,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  "images/filled-search.svg",
                  semanticsLabel: "search",
                  height: 24,
                  width: 24,
                ),
                icon: SvgPicture.asset(
                  "images/line-search.svg",
                  semanticsLabel: "search",
                  height: 24,
                  width: 24,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                activeIcon:
                    ImageIcon(NetworkImage(_auth.currentUser!.photoURL!)),
                icon: ImageIcon(NetworkImage(_auth.currentUser!.photoURL!)),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }
}
