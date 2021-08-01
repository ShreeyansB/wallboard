import 'package:flutter/material.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({Key? key}) : super(key: key);

  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < 12; i++)
            Container(
              margin: EdgeInsets.all(15),
              height: 130,
              color: Colors.teal.shade700,
            )
        ],
      ),
    );
  }
}
