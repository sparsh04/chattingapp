import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_kisan/Component/category_roundcard.dart';
import 'package:my_kisan/accessories/Position.dart';
import 'package:my_kisan/constant.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/Maindrawer.dart';
import 'package:my_kisan/screens/notification_screen.dart';
import 'package:my_kisan/screens/product_details.dart';
import 'package:my_kisan/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static String routName = "/home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var categorystream,
      notificationstream,
      position,
      location,
      address,
      carttotal,
      cartitem,
      resturantstream;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCcategories() async {
    return FirebaseFirestore.instance.collection("Category").snapshots();
  }

  getcategories() async {
    categorystream = await getCcategories();
    setState(() {});
  }

  getNotifications() async {
    notificationstream = await getuserNotifications();
    setState(() {});
  }

  getuserresturant() async {
    resturantstream = await getresturants();
    setState(() {});
  }

  getCcarttotal() async {
    carttotal = await getcarttotal();
    setState(() {});
  }

  getlocation() async {
    position = await Locationa().determinePosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
    setState(() {});
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemark[0];
    address = '${place.administrativeArea},${place.subAdministrativeArea}';
    setState(() {});
  }

  doThisOnLaunch() async {
    await getlocation();
    await getcategories();
    await getNotifications();
    await getCcarttotal();
    await getuser();
    await getuserresturant();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    doThisOnLaunch();
    setState(() {
      this.cartitem = getuser();
    });
    super.initState();
  }

  Future<Stream<QuerySnapshot>> getuserNotifications() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("Notifications")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getcarttotal() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.phoneNumber)
        .collection("cart")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getresturants() async {
    return FirebaseFirestore.instance.collection("Resturants").snapshots();
  }

  Future<int> getuser() async {
    final userdoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();

    final userdata = userdoc.data();
    print(userdata);
    var cartitems = userdata!['totalitems'];
    return cartitems;
  }

  Widget Offersbody({
    required String image,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 130,
                child: SvgPicture.asset(image),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int activeIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: Drawer(
          child: MainDrawer(),
          backgroundColor: greencolor,
        ),
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: greencolor,
          centerTitle: true,
          title: Text("My Kisan"),
          leading: IconButton(
            onPressed: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            icon: Image.asset(
              "assets/images/paragraph.png",
              color: Colors.white,
              width: 30,
            ),
          ),
          actions: [
            StreamBuilder(
                stream: notificationstream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  {
                    return IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, NotificationScreen.routName);
                        },
                        icon: Badge(
                            badgeContent: Text(
                              snapshot.hasData
                                  ? '${snapshot.data!.docs.length}'
                                  : "0",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            child: Icon(
                              Icons.notifications,
                              size: 25,
                            )));
                  }
                }),
            StreamBuilder(
                stream: carttotal,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CartScreen.routName);
                      },
                      icon: Badge(
                          badgeContent: Text(
                            snapshot.hasData
                                ? '${snapshot.data!.docs.length}'
                                : "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 25,
                          )));
                }),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                //location
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 15, left: 10),
                    height: Height / 20,
                    // width: Width * 0.4 - 10,
                    decoration: BoxDecoration(
                      color: whitecolors,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                '${address}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 55),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: [
                    Text("Popular Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 40)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //cateogry list
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: StreamBuilder(
                  stream: categorystream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {},
                              child: CategoryRoundCard(
                                  image: map["Imgurl"], name: map["Name"]),
                              // child: Container(

                              //     child: Text(map['Name'])),
                            );
                          });
                    } else {
                      return Container(
                          height: 40, child: const CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //slider
            Container(
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      //  enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      initialPage: 1,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: 2),
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                      autoPlay: true,
                      height: MediaQuery.of(context).size.height * 0.2 + 5,
                    ),
                    items: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/delivery_banner.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/delivery_banner.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/delivery_banner.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildIndicator(),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Column(children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 10),
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "assets/images/offer.png",
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                "Offers for you",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            55),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //offers body
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Offersbody(image: "assets/images/discount_50.svg"),
                      Offersbody(image: "assets/images/discount_25.svg"),
                      Offersbody(image: "assets/images/discount_15.svg"),
                      Offersbody(image: "assets/images/discount_10.svg"),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              "assets/images/offer.png",
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    "All Resturent",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textcolorblack,
                                        fontSize:
                                            MediaQuery.of(context).size.height /
                                                55),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            //   Container(
            //   height: 300,
            //    child:
            StreamBuilder(
                stream: resturantstream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(resturantstream);
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Container(
                      // alignment: Alignment.center,
                      height: snapshot.data!.docs.length * 120.00,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return RestaurantCard(
                            image: map['imgurl'],
                            resturantname: map['name'],
                            submenus: map['style'],
                            ontap: () {
                              // Navigator.pushNamed(context, ProductDetail.routName);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetail(map: map)));
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
            //  ),
          ]),
        ));
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: 3,
        effect: ExpandingDotsEffect(
          dotHeight: 8,
          dotWidth: 10,
          activeDotColor: orangecolor,
          dotColor: yellowcolor,
        ),
      );
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    Key? key,
    required this.image,
    required this.resturantname,
    required this.submenus,
    required this.ontap,
  }) : super(key: key);
  final String image;
  final String resturantname;
  final String submenus;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // SizedBox(
              //     height: screenHeight(context) * 0.15,
              //     child: Image.network(image)),
              Container(
                // margin: EdgeInsets.only(left: 15, top: 10),
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.height * 0.1 - 10,
                // color: Colors.red,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resturantname,
                    style: headingstyle(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    submenucard(name: submenus),
                  ]),
                ],
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container submenucard({required String name}) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        submenus,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
