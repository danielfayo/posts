import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:posts/constants/colors.dart';
import 'package:posts/firebase_options.dart';
import 'package:posts/providers/posts_provider.dart';
import 'package:posts/screens/auth_screen.dart';
import 'package:posts/screens/posts_screen.dart';
import 'package:posts/screens/profile_screen.dart';
import 'package:posts/screens/search_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.dmSansTextTheme()),
        home: _auth.currentUser == null ? AuthScreen() : const App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
      body: IndexedStack(
        index: _currentScreen,
        children: _screens,
      ),
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
                activeIcon: _auth.currentUser?.photoURL != null
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: kPrimary),
                            borderRadius: BorderRadius.circular(99)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99.0),
                          child: FadeInImage(
                              placeholder:
                                  const AssetImage("images/placeholder.png"),
                              image: NetworkImage(_auth.currentUser!.photoURL!),
                              width: 20,
                              height: 20,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/placeholder.png',
                                  fit: BoxFit.fitWidth,
                                  width: 24,
                                  height: 24,
                                );
                              }),
                        ),
                      )
                    : const Icon(Icons.account_circle),
                icon: _auth.currentUser?.photoURL != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(99.0),
                        child: FadeInImage(
                            placeholder:
                                const AssetImage("images/placeholder.png"),
                            image: NetworkImage(_auth.currentUser!.photoURL!),
                            width: 24,
                            height: 24,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/placeholder.png',
                                fit: BoxFit.fitWidth,
                                width: 24,
                                height: 24,
                              );
                            }),
                      )
                    : const Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }
}
