import 'package:flutter/material.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({ Key? key }) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < 12; i++)
            Container(
              margin: EdgeInsets.all(15),
              height: 130,
              color: Colors.pink.shade800,
            )
        ],
      ),
    );
  }
}