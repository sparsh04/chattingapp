import 'package:flutter/material.dart';

class CategoryRoundCard extends StatelessWidget {
  const CategoryRoundCard({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);
  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 10),
          height: MediaQuery.of(context).size.height / 12,
          width: MediaQuery.of(context).size.height * 0.1 - 10,
          // color: Colors.red,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(image),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 150,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            name,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 55,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
