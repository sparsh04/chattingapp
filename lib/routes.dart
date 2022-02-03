import 'package:flutter/material.dart';
import 'package:my_kisan/screens/Cart_Screen.dart';
import 'package:my_kisan/screens/home_screen.dart';
import 'package:my_kisan/screens/notification_screen.dart';

final Map<String, WidgetBuilder> routes = {
  CartScreen.routName: (context) => const CartScreen(),
  HomeScreen.routName: (context) => const HomeScreen(),
  NotificationScreen.routName: (context) => const NotificationScreen(),
};
