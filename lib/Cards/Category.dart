import 'package:flutter/material.dart';


class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            child: RawMaterialButton(
              shape: CircleBorder(),
              child: Padding(padding: EdgeInsets.all(4) ,child: Image.asset('image/bag.png')),
              onPressed: (){

              },
            ),
          ),
          Text("Bag", style: TextStyle(fontSize: 13),)
        ],
      ),
    );
  }
}
