import 'package:bella_mall/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'Utility.dart';
import 'package:path/path.dart' as path;

class AddItem extends StatefulWidget {
  FirebaseApp app;
  AddItem({this.app});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController nameType = TextEditingController();

  String name= '';
  String type= '';
  String price = "";
  String barcode = "";

  File imageFile;
  String imageString;

  String _chosenValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Item"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  onChanged: (text) {
                    setState(() {
                      name = text;
                    });
                  },
                ),
                SizedBox(height: 25,),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                  ),
                  onChanged: (text2) {
                    setState(() {
                      price = text2;
                    });
                  },
                ),
                SizedBox(height: 25,),
               Row(
                 children: <Widget>[
                  IconButton(
                      icon: Icon(FontAwesomeIcons.qrcode),
                      onPressed: (){
                       setState(() {
                         Future<String> code = getCode();
                       });
                      }
                  ),
                   Expanded(
                     child: TextField(
                       controller: barcodeController,
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: 'Barcode',
                       ),
                       onChanged: (text3) {
                         setState(() {
                           barcode = text3;
                         });
                       },
                     ),
                   ),
                 ],
               ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16)),
                  width: 150,
                  height: 150,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: isImage(),
                    onPressed: () {
                      ShowDialig(context);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3.0),
                  margin: EdgeInsets.only(top: h * 0.055),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(15),
                    color: Colors.black12
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Types').snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        types = [];
                        snapshot.data.docs.forEach((element) {
                             types.add(element['type']);
                        });
                        return DropdownButton(
                          style: TextStyle(color: Colors.black),
                          items: types.map<DropdownMenuItem>((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint: Text("Please choose a Type", style: TextStyle( color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _chosenValue = value;
                              type = value;
                            });
                          },
                          value: _chosenValue,
                        );
                      }
                      else {
                        return DropdownButton(
                          style: TextStyle(color: Colors.black),
                          items: types.map<DropdownMenuItem>((value) {
                            return DropdownMenuItem(
                              value: value, child: Text(value,style:TextStyle(color:Colors.black),),);
                          }).toList(),
                          hint: Text("Please choose a Type", style: TextStyle( color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: h * 0.10,),
               buttonStyle("ADD item"),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          setState(() {
            showAlertDialog(context);
          });
        },
      ),
    );
  }

  final database = FirebaseFirestore.instance;

  addItem() async {

    var db = database.collection("Items");

    var id = await database.collection("Items").get().then((value) => value.size);

    print(id);
    Item item;
    if(name != '' && price != '' && type != '' && barcode != '' && imageFile != null){
      id += 1;
      item = Item(id.toString() ,name, price, type, barcode, imageString);
      db.doc().set(<String, Object>{
        "id" : item.id,
        "name": item.name,
        "price": item.price,
        "type": item.type,
        "barcode": item.barcode,
        "image": item.image,
      });

      toastInsert();

      nameController.text = "";
      typeController.text = "";
      barcodeController.text = "";
      priceController.text = "";
      nameType.text = "";
      imageFile = null;
      setState(() {
      });

    }
    else{
      toastError();
    }

  }

  toastError(){
    Toast.show("Insert Data Not Successful", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.red);
  }

  toastInsert(){
    Toast.show("Insert Data Successful", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.green);
  }

  var types =[];


  _openCamera(BuildContext context) async {
    File picture = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 2080, maxHeight: 3340);
    File image = await cropImage(picture);
    this.setState(() {
      imageString = Utility.base64String(image.readAsBytesSync());
      imageFile =image;
    });
    Navigator.of(context).pop();
  }

  _opnGallary(BuildContext context) async {
    File picture = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 2340);
    File image = await cropImage(picture);
    this.setState(() {
      imageFile = image;
      imageString = Utility.base64String(image.readAsBytesSync());
    });
    Navigator.of(context).pop();

  }

  File croppedFile;

    cropImage(File image) async {
    print("ziad");
    croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 700,
      maxHeight: 700,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    return await croppedFile;
  }

  isImage() {
    if (imageFile == null) {
      return Icon(
        Icons.add_a_photo,
        size: 100,
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child:Image.file(
          imageFile ,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Future<void> ShowDialig(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Chioce Your Image"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Text("Opne Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Text("Opne Gallary"),
                      onTap: () {
                        _opnGallary(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
   getCode()async{
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'CANCEL',
        true,
        ScanMode.BARCODE);
    setState(() {
      barcodeController.text = barcodeScanRes;
      barcode = barcodeScanRes;
    });
  }

  Widget buttonStyle(String title){
    double w = MediaQuery.of(context).size.width;
    return  Container(
      width: w * 0.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue
      ),
      child: FlatButton(
        child: Text(title, style: TextStyle(color: Colors.white),),
        onPressed: (){
          addItem();
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
     showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        var mediaQuery = MediaQuery.of(context);

        return AnimatedContainer(
          padding: mediaQuery.padding,
          duration: const Duration(milliseconds: 300),
          child: AlertDialog(
            title: Text("Add type"),
            content: TextField(
              controller: nameType,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCEL"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  var db = database.collection("Types");
                  Navigator.pop(context, nameType.text);
                  db.add({"type" : nameType.text}).then((value) => {
                   toastInsert()
                  }).catchError((error){
                    toastError();
                  });
                  nameType.clear();
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}

