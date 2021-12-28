import 'dart:async';
import 'package:bella_mall/AddItem.dart';
import 'package:bella_mall/Cards/Category.dart';
import 'package:bella_mall/SearchList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Item.dart';
import 'Lists/HomeList.dart';
import 'Lists/listItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Cards/itemCard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Bella-Mall",
            style:
                TextStyle(color: Colors.white, fontStyle: FontStyle.italic,fontSize: 30),
          ),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: RawMaterialButton(
                child: Icon(
                  Icons.add_circle,
                  size: 30,
                ),
                fillColor: Colors.grey,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()));
                },
              ),
            )
          ],
        ),
        body: RefreshIndicator(
            child: Homepage(),
          onRefresh: _refresh,
        ),
        //              Padding(
//                padding: EdgeInsets.only(left: 10,top: 10),
//                child: Container(
//                  height: h * 0.11,
//                  child:ListView.separated(
//                      scrollDirection: Axis.horizontal,
//                      itemCount: 5,
//                      separatorBuilder: (context, index) => SizedBox(width: 10,),
//                      itemBuilder: (context, i){
//                        return Category();
//                      }),
      ),
    );
  }

  Future<Null> _refresh() async{
    setState(() {

    });
    return null;
  }

}

class Homepage extends StatefulWidget {
  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
//  StreamSubscription<ConnectivityResult> subscription;
  bool internet = false;

  @override
  void initState() {
    getType();
    super.initState();
  }

  final database = FirebaseDatabase.instance;

  var types =[];
  getType() async{
    var db = database.reference().child("Types");
    db.once().then((DataSnapshot snapshot) {
//      print('Data : ${snapshot.value}');
      var value = snapshot.value;
      var key = snapshot.value.keys;
      for(var k in key){
        types.add(value[k]["type"]);
//         print(value[k]["type"]);
      }
      setState(() {
        types = types;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: OrientationBuilder(builder: (context, orientation) {
        return Column(children: <Widget>[
          //bo search krdn
          Container(
            height: size.height *0.06 ,
            width: size.width * 1,
            margin: EdgeInsets.symmetric(vertical: size.height *0.01, horizontal: size.width *0.01),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList('all')));
              },
              child:  ListTile(
                  leading: Text("Search Product..."),
                  trailing: Icon(Icons.search),
              ),
              style: OutlinedButton.styleFrom( primary: Colors.black,
                shape: StadiumBorder(),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02,),

            Expanded(
              child:  StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Types').snapshots(),
                builder: (context , snapshot){
                  if(snapshot.hasData){
//                    print(snapshot.data.docs.length);
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i){
                        return Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              HomeList(snapshot.data.docs[i]['type']),
                              MyDivider(),
                            ],
                          ),
                        );},
                    );
                  }
                  else if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
                    return Center(child: Text("NO Internet"));
                  }
                },
              ),),

//                Container(
//                  width: double.infinity,
//                  height: size.height * 0.79,
//                  child: SingleChildScrollView(
//                    child: Column(
//                      children: [
//                        Padding(
//                          padding: EdgeInsets.symmetric(vertical: 10),
//                          child: Container(
//                            color: Colors.red,
//                            width: size.width,
//                            height: size.height * 0.15,
//                            child: Image.asset(
//                              "image/shoes.png",
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                        ),
//
////                            Categories(),
//                        SizedBox(height: 15,),
//
//                        /////// Digital Section
//                        FutureBuilder<List>(
//                          future: types,
//                            builder: (context, snapshot){
//                              return  ListView.builder(
//                                itemCount: 2,
//                                itemBuilder: (context, snap){
//                                  if(snapshot.hasData){
//                                    print(snapshot.data);
//                                  }
//
//                                  return null;
////                                  return  Padding(
////                                    padding: EdgeInsets.only(left: 10),
////                                    child: Column(
////                                      crossAxisAlignment: CrossAxisAlignment.start,
////                                      children: <Widget>[
////                                        HomeList(snapshot.data),
////                                        MyDivider(),
////                                      ],
////                                    ),
////                                  );
//                                },
//                              );
//                            }
//                        ),
//                        Padding(
//                          padding: EdgeInsets.only(left: 10),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              HomeList("Home Application"),
//                              MyDivider(),
//                            ],
//                          ),
//                        ),
//                        /////// Home Application
//                        Padding(
//                          padding: EdgeInsets.only(left: 10),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              HomeList("Home Application"),
//                              MyDivider(),
//                              CheckAllPruduct()
//                            ],
//                          ),
//                        ),
//
//                        Column(
//                          children: <Widget>[
//                            Text("Hot deals!!"),
//                            Container(
//                              margin: EdgeInsets.all(10),
//                              height: size.height * 0.63,
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20),
//                                  border: Border.all(
//                                      color: Colors.red, width: 3.0)),
//                              child: Image.asset("image/shoes.png"),
//                            )
//                          ],
//                        ),

                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            height: size.height * 0.07,
                            color: Colors.black12,
                            width: double.infinity,
                            child: LinkSocial()
                        )

        ]);
      }),
    );
  }

  OpenUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  LinkSocial() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {
            OpenUrl("https://www.facebook.com/pg/bella___mall-109140938048657");
          },
          elevation: 2.0,
          child: Icon(
            FontAwesomeIcons.facebook,
            size: 30,
            color: Colors.blue,
          ),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: () {
            String phone = "+9647504994743";
            String url = "whatsapp://send?phone=$phone"+"&text=Hi";
            OpenUrl(url);
            },

          elevation: 2.0,
          child: Icon(
            FontAwesomeIcons.whatsapp,
            size: 30,
            color: Colors.red,
          ),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: () {
            OpenUrl("https://www.instagram.com/Bella___Mall/");
          },
          elevation: 2.0,
          child: Icon(
            FontAwesomeIcons.instagram,
            size: 30,
            color: Colors.red,
          ),
          shape: CircleBorder(),
        ),
        RawMaterialButton(
          onPressed: () {
            OpenUrl("https://www.snapchat.com/Bella Mall/");
          },
          elevation: 2.0,
          child: Icon(
            FontAwesomeIcons.snapchat,
            size: 30,
            color: Colors.red,
          ),
          shape: CircleBorder(),
        )
      ],
    );
  }

  Widget Reckalm(String image) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget CheckAllPruduct() {
    return ListTile(
      leading: Text(
        "Check All Products",
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
      ),
      trailing: Icon(Icons.navigate_next),
      onTap: () {},
    );
  }

  Widget MyDivider() {
    return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Divider(
          color: Colors.black45,
        ));
  }
}
