import '../Cards/itemCard.dart';
import 'package:flutter/material.dart';


class listItem extends StatefulWidget {
  @override
  _listItemState createState() => _listItemState();
}

class _listItemState extends State<listItem> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bella-Mall"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//           itemCrad()
          ],
        ),
      ),
    );
  }
}
