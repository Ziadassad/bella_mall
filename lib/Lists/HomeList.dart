import 'package:bella_mall/Cards/itemCard.dart';
import 'package:bella_mall/Item.dart';
import 'package:bella_mall/SearchList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeList extends StatefulWidget {
  final String NameType;
  HomeList(this.NameType);
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  List<Item> list = [];
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async{
    var database = FirebaseFirestore.instance.collection("Items");

    database.get().then((element) => {
      element.docs.forEach((value) {
        int id = value['id'];
        String name = value['name'];
        String price = value['price'];
        String type = value['type'];
        String barcode = value['barcode'];
        String image = value['image'];
        Item item = Item(id.toString(),name, price, type, barcode, image);
        list.add(item);
      })
    });

  }

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance.reference().child("Items");
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("${widget.NameType}", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),),
        MyDivider(),
        FlatButton(child:Container(
          height: size.height * 0.05 ,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Text("See All"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
        ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList(widget.NameType)));
            }),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          height: MediaQuery.of(context).size.height *0.351,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Items").where('type', isEqualTo: widget.NameType).snapshots(),
            builder: (context, snapshot){
//              print(snapshot.data);
              if(snapshot.hasData){
                return   ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context , i) => Padding(padding: EdgeInsets.symmetric(vertical: 30), child: VerticalDivider(color: Colors.black26,)),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context , i) {
                    var data = snapshot.data.docs[i];
                    return Padding(padding: EdgeInsets.all(10),
                        child: ItemCard2(data['name'], data['image'], data['price'])
                    ) ;
                  },
                );
              }else
                return CircularProgressIndicator();
              },
          ),
        ),
      ],
    );
  }

  Widget MyDivider(){
    return Padding(padding: EdgeInsets.only(right: 10), child: Divider(color: Colors.black45,));
  }
}

