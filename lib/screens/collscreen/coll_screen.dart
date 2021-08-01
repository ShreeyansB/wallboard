import 'package:flutter/material.dart';

class CollScreen extends StatefulWidget {
  const CollScreen({Key? key}) : super(key: key);

  @override
  _CollScreenState createState() => _CollScreenState();
}

class _CollScreenState extends State<CollScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < 12; i++)
            Container(
              margin: EdgeInsets.all(15),
              height: 130,
              color: Colors.amber.shade900,
            )
        ],
      ),
    );
  }
}
