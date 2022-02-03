import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({Key? key}) : super(key: key);

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  List items = [
    {'name': 'Dosa', 'count': '2'},
    {'name': 'Paneer', 'count': '2'},
    {'name': 'Cake', 'count': '1'},
    {'name': 'Dosa', 'count': '4'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking Order"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, bottom: 20),
              child: Text(
                "Track your Order",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Track(
              text: 'Order Placed',
              done: true,
            ),
            Divider(),
            Track(
              text: 'Order Accepted',
              done: true,
            ),
            Divider(),
            Track(
              text: 'Order Dispatched',
              done: false,
            ),
            Divider(),
            Track(
              text: 'Order Delivered',
              done: false,
            ),
          ],
        ),
      ),
    );
  }
}

class Track extends StatelessWidget {
  final String text;
  final bool done;
  const Track({
    Key? key,
    required this.text,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: done ? Colors.green : Colors.grey,
            radius: 11,
            child: Icon(Icons.check, size: 18, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Container(
            height: 25,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 5,
            ),
          ),
        ],
      ),
    );
  }
}
