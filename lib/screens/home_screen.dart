import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/state/user_provider.dart';
import 'package:flutter_study_1/widgets/expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';
import 'home/items_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Text('정왕동', style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: [
            IconButton(onPressed: () {
              // provider userdata logout
              FirebaseAuth.instance.signOut(); // firebase logout
            }, icon: Icon(Icons.logout)),
            IconButton(onPressed: () {

            }, icon: Icon(Icons.search)),
            IconButton(onPressed: () {

            }, icon: Icon(Icons.menu))
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            _currentBottomNavIndex = idx;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(_currentBottomNavIndex==0 ? 'assets/imgs/icons/home_selected.png' : 'assets/imgs/icons/home.png')),
            label: '홈'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(_currentBottomNavIndex==1 ? 'assets/imgs/icons/placeholder_selected.png' : 'assets/imgs/icons/placeholder.png')),
              label: '내주변'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(_currentBottomNavIndex==2 ? 'assets/imgs/icons/chat_selected.png' : 'assets/imgs/icons/chat.png')),
              label: '채팅'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(_currentBottomNavIndex==3 ? 'assets/imgs/icons/user_selected.png' : 'assets/imgs/icons/user.png')),
              label: '내정보'
          )
        ],
      ),
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: [
          ItemsPage(),
          Container(color:Colors.accents[3]),
          Container(color:Colors.accents[6]),
          Container(color:Colors.accents[9])
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 98,
        children: [
          ActionButton(
            onPressed: () {
              context.beamToNamed('/input');
            },
            icon: const Icon(Icons.format_size, color: Colors.white),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.insert_photo, color: Colors.white),
          ),
          ActionButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam, color: Colors.white),
          ),
        ],
      ),
    );
  }
}