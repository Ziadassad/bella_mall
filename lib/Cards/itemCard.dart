import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../Utility.dart';


class ItemCard2 extends StatelessWidget {

  String image;
  String name;
  String price;

  ItemCard2(this.name ,this.image, this.price);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: 150,
      height: 180,
      child: Column(
        children: <Widget>[
          Text(name , style: TextStyle(color: Colors.blue ,fontSize: 13), softWrap: true,),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              color: Colors.transparent,
              child: Container(width: w * 0.3, height: h * 0.24,
                  child: Utility.imageFromBase64String(image))
            ),
            ),
          Text("\IQ ${price}")
        ],
      ),
    );
  }
}


class itemCrad extends StatefulWidget {
  String type;
  String barcode;
  String name;
  String price;
  String image;
  String id;
  itemCrad(this.id, this.type, this.name, this.price, this.barcode,this.image);
  @override
  _itemCradState createState() => _itemCradState();
}

class _itemCradState extends State<itemCrad> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.01, vertical: h * 0.01),
      width: w * 0.98,
      height: h * 0.20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: w*0.02, vertical: h*0.01),
            child: Container(
              width: w * 0.3,
                height: h *0.3,
                child: Utility.imageFromBase64String(widget.image)
            ),
          ),
          Container( width: 1, height: h * 0.18, color: Colors.black26,),
         SizedBox(width: w * 0.04),
         Container(
           width: 180,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: <Widget>[
               Text("Type : "+widget.type),
               Text("Name :" + widget.name),
               Text("BarCode : "+ widget.barcode ,overflow: TextOverflow.clip,
                 maxLines: 1,
                 softWrap: false,),
               Text("Price : "+ widget.price),
             ],
           ),
         ),
          FlatButton(
            minWidth: w * 0.12,
            height: h *0.07,
            color: Colors.redAccent,
            padding: EdgeInsets.all(0),
              onPressed: (){
//               print(widget.id);
               showDi(context);
              },
              child: Icon(Icons.delete_forever))
        ],
      ),
    );
  }

  var databse = FirebaseDatabase.instance.reference();

   showDi(context) {

     showDialog(
         context: context,
         builder: (context) {
           return AlertDialog(
             title: Text('Delete Item !'),
             content: Text('Do you want delete this Item ?'),
             actions: <Widget>[
               FlatButton(
                   onPressed: () {
                     print(widget.id);
                     print( FirebaseFirestore.instance.collection("Items").doc(widget.id).delete().then((value) => {
                       toastDelete()
                     }).catchError((error){
                       toastError();
                     }));
                     Navigator.of(context).pop();
                   },
                   child: Text('OK')),
               FlatButton(
                   onPressed: () => Navigator.of(context).pop(),
                   child: Text('CANCEL')),
             ],
           );
         });
  }

  toastError(){
    Toast.show("Delete item not Successful", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
  }

  toastDelete(){
    Toast.show("Delete item Successful", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.green);
  }
}
