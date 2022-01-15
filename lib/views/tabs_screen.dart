//import 'package:chattingapp/videoagora/videocall.dart';
// ignore_for_file: prefer_typing_uninitialized_variables
import "dart:core";
import 'package:chattingapp/groups/group_chat_screen.dart';
import 'package:chattingapp/views/home.dart';
import 'package:chattingapp/views/settings.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabsScreen extends StatefulWidget {
  //const TabsScreen({Key? key}) : super(key: key);
  var initialindex;
  TabsScreen(this.initialindex, {Key? key}) : super(key: key);
  //final List<Meals> favcreen;
  //TabsScreen(this.favcreen);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];

  int _selectpageindex = 0;

  @override
  void initState() {
    _selectpageindex = widget.initialindex;
    _pages = [
      {'page': const Home(), 'title': 'Chats'},
      {'page': const GroupChatHomeScreen(), 'title': 'Groups'},
      {'page': const Setting(), 'title': 'Setting'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectpageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //we will add bottom navigation bar
    return Scaffold(
      body: _pages[_selectpageindex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _selectpageindex,
        //type: BottomNavigationBarType.shifting,
        backgroundColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.chat_sharp),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );

    //the way to add upwards navigation bar
    //to use in other projects when and where needed

    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Meals'),
    //       bottom: TabBar(
    //         tabs: <Widget>[
    //           Tab(
    //             icon: Icon(
    //               Icons.category,
    //             ),
    //             text: 'Categories',
    //           ),
    //           Tab(
    //             icon: Icon(
    //               Icons.star,
    //             ),
    //             text: 'Favourites',
    //           ),
    //         ],
    //       ),
    //     ),
    //     body: TabBarView(
    //       children: <Widget>[
    //         CategoryScreen(),
    //         FavouritesScreen(),
    //       ],
    //     ),
    //   ),
    // );
  }
}
