import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:my_kisan/screens/CustomCard.dart';

class ProductDetail extends StatefulWidget {
  static String routName = "/product_detail";
  var map;
  ProductDetail({required this.map});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff35751f),
        title: Text("Rolex Hotel"),
        centerTitle: true,
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                // indicatorColor: Colors.black,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                  //  insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                ),
                tabs: [
                  Tab(text: "Dishes"),
                  Tab(text: "Reviews"),
                  Tab(text: "Moreinfo"),
                  Tab(text: "Food Menu"),
                ],
                controller: _tabController,
              ),
            ),
            ExpandableTheme(
                data: ExpandableThemeData(useInkWell: true),
                child: Column(
                  children: [Card1(), Card2(), Card3()],
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

List<ExpandableController> controllerList = [
  ExpandableController(),
  ExpandableController(),
  ExpandableController(),
];

int currentIndex = -1;

// card 1  Screen
class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                controller: controllerList[0],
                theme: const ExpandableThemeData(
                  iconColor: Colors.black,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: InkWell(
                  onTap: () {
                    currentIndex = 0;
                    for (int i = 0; i < controllerList.length; i++) {
                      if (i == currentIndex) {
                        controllerList[i].expanded = true;
                      } else {
                        controllerList[i].expanded = false;
                      }
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(),
                            Text(
                              "Rice Preparation",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ),
                collapsed: Container(),
                expanded: Column(
                  children: [
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// card 2 Screen
class Card2 extends StatefulWidget {
  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        // elevation: 1.0,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                controller: controllerList[1],
                theme: const ExpandableThemeData(
                  iconColor: Colors.black,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: InkWell(
                  onTap: () {
                    currentIndex = 1;
                    for (int i = 0; i < controllerList.length; i++) {
                      if (i == currentIndex) {
                        controllerList[i].expanded = true;
                      } else {
                        controllerList[i].expanded = false;
                      }
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(),
                            Text(
                              "Starters",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ),
                collapsed: Container(),
                expanded: Column(
                  children: [
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// card 3 Screen
class Card3 extends StatefulWidget {
  const Card3({Key? key}) : super(key: key);

  @override
  _Card3State createState() => _Card3State();
}

class _Card3State extends State<Card3> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  controller: controllerList[2],
                  theme: const ExpandableThemeData(
                    iconColor: Colors.black,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: InkWell(
                    onTap: () {
                      currentIndex = 2;
                      for (int i = 0; i < controllerList.length; i++) {
                        if (i == currentIndex) {
                          controllerList[i].expanded = true;
                        } else {
                          controllerList[i].expanded = false;
                        }
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(),
                              Text(
                                "Soft Drink",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                  ),
                  collapsed: Container(),
                  expanded: Column(children: [
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                    CustomeProductCard(
                      image: "assets/images/vegetabl.png",
                      name: "Angara Chilly",
                      title: 'in Starter',
                      price: '₹ 310',
                      index: 1,
                      map: null,
                      productid: "1",
                    ),
                  ]),
                  builder: (_, collapsed, expanded) {
                    return Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
