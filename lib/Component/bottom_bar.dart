import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/Categaory_product.dart';
import 'package:my_kisan/screens/Custom_product.dart';
import 'package:my_kisan/screens/Search_bar.dart';
import 'package:my_kisan/screens/home_screen.dart';
import 'package:my_kisan/size_config.dart';

class BottomBar extends StatefulWidget {
  //const BottomBar({Key? key}) : super(key: key);
  var index;
  BottomBar(this.index);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  List<Widget> screen = [
    HomeScreen(),
    CategoryProduct(),
    SearchBar(),
    CustomProduct(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectedIndex],
      bottomNavigationBar: Container(
          height: 60,
          color: whitecolors,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BottomAppBar(
                color: whitecolors,
                elevation: 2,
                // color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconBottomBar(
                          icon: "assets/icons/home.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          selected: _selectedIndex == 0,
                          text: 'Home',
                        ),
                        IconBottomBar(
                          icon: "assets/icons/package.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          selected: _selectedIndex == 1,
                          text: 'Categories',
                        ),
                        IconBottomBar(
                          icon: "assets/icons/search.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          selected: _selectedIndex == 2,
                          text: 'Search',
                        ),
                        IconBottomBar(
                          icon: "assets/icons/heart.svg",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
                          },
                          selected: _selectedIndex == 3,
                          text: 'Whshlist',
                        )
                      ],
                    )),
              ))),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final String text;
  final bool selected;
  final String icon;
  final Function() onPressed;

  const IconBottomBar(
      {key,
      required this.text,
      required this.selected,
      required this.onPressed,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: greencolor.withOpacity(0.5),
      onTap: onPressed,
      child: SizedBox(
        width: screenWidth(context) / 4.5,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            icon,
            color: selected ? greencolor : textcolorgrey,
          ),
          SizedBox(
            height: 10,
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  // height: .10,
                  color: selected ? Colors.green : Colors.grey)),
        ]),
      ),
    );
  }
}
