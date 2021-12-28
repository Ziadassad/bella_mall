import 'package:bella_mall/Cards/itemCard.dart';
import 'package:bella_mall/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SearchList extends StatefulWidget {
  String type;
  SearchList(this.type);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  TextEditingController barcodeController = TextEditingController();

  String barcode;
  List<Item> list = [];
  List<Item> listSearch = [];
  var database;


  @override
  void initState() {
    database = FirebaseFirestore.instance.collection("Items");
    getAllData(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            title: Text(
              "Search List",
              style:
              TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
            backgroundColor: Colors.blue,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child:  Column(
              children: [
                Container(
                  height: size.height * 0.1,
                  padding:
                  const EdgeInsets.only(top: 10.0, left: 8, right: 8, bottom: 10),
                  child: TextFormField(
                    controller: barcodeController,
                    onChanged: onSearchTextChanged,
                    decoration: new InputDecoration(
                      errorStyle: TextStyle(fontSize: 18.0),
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          )),
                    ),
                  ),
                  ),
                Expanded(
                  child: Container(
                    child:StreamBuilder(
                      stream: widget.type != 'all'? database.where('type', isEqualTo: widget.type).snapshots() : database.snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
//                           getAllData(widget.type);

                          return barcodeController.text.length > 0 ? ListView.builder(
                              itemCount: listSearch.length,
                              itemBuilder: (context, i){

                                return itemCrad(listSearch[i].id.toString(),listSearch[i].type, listSearch[i].name, listSearch[i].price, listSearch[i].barcode,listSearch[i].image);
                              })
                          :
                          ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, i){
//                                var data = snapshot.data.docs[i];

                                return itemCrad(list[i].id.toString(),list[i].type, list[i].name, list[i].price, list[i].barcode,list[i].image);
                              });
                        }else
                          return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getCode();
          },
          child: const Icon(
            Icons.camera_enhance,
            size: 35,
          ),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
  getCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'CANCEL', true, ScanMode.BARCODE);
    setState(() {
      barcodeController.text = barcodeScanRes;
      barcode = barcodeScanRes;
    });

    print(barcodeController.text);
    onSearchTextChanged(barcodeController.text);
  }


   getAllData(String t) async{

     var li;

//     print(t);

     if(t == "all"){
       list = [];
       await database.get().then((v) =>{
         for(int i = 0; i < v.size ;i++){
           li =  v.docs[i],
           list.add(Item(li.id,li['name'], li['price'], li['type'], li['barcode'], li['image'])),
         }
       });
       setState(() {

       });
//       print(list[0].id);
     }
     else{
       list = [];
       await database.where('type', isEqualTo: widget.type).get().then((v) =>{
         for(int i = 0; i < v.size ;i++){
           li =  v.docs[i],
           list.add(Item(li.id,li['name'], li['price'], li['type'], li['barcode'], li['image'])),
         }
       });
//       print(list[0].id);
     }
  }



  onSearchTextChanged(String text) {
    barcodeController.text = text;


    listSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    list.forEach((userDetail) {
      if (userDetail.name.contains(text) || userDetail.barcode.contains(text))
        listSearch.add(userDetail);
    });
    setState(() {});
    print(listSearch.length);
    return listSearch;
  }

}